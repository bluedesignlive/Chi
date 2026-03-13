#include "waveformgenerator.h"
#include <QAudioFormat>
#include <QAudioBuffer>
#include <QtMath>
#include <algorithm>

WaveformGenerator::WaveformGenerator(QObject *parent)
    : QObject(parent)
{
    m_decoder = new QAudioDecoder(this);

    // Mono float PCM at low rate — fast decode, enough for visuals
    QAudioFormat fmt;
    fmt.setSampleRate(22050);
    fmt.setChannelCount(1);
    fmt.setSampleFormat(QAudioFormat::Float);
    m_decoder->setAudioFormat(fmt);

    connect(m_decoder, &QAudioDecoder::bufferReady, this, &WaveformGenerator::onBufferReady);
    connect(m_decoder, &QAudioDecoder::finished,    this, &WaveformGenerator::onFinished);

    // error() is overloaded in QAudioDecoder — use qOverload
    connect(m_decoder, qOverload<QAudioDecoder::Error>(&QAudioDecoder::error),
            this, [this](QAudioDecoder::Error err) { onDecoderError(err); });
}

QUrl WaveformGenerator::source() const { return m_source; }

void WaveformGenerator::setSource(const QUrl &url) {
    if (m_source == url) return;
    m_source = url;
    emit sourceChanged();
    startDecode();
}

QList<qreal> WaveformGenerator::samples() const { return m_samples; }
bool WaveformGenerator::loading() const { return m_loading; }
bool WaveformGenerator::ready()   const { return m_ready; }

void WaveformGenerator::startDecode() {
    m_decoder->stop();
    m_rawPeaks.clear();
    m_totalFrames = 0;
    m_ready = false;
    emit readyChanged();

    if (m_source.isEmpty()) return;

    m_loading = true;
    emit loadingChanged();

    m_decoder->setSource(m_source);
    m_decoder->start();
}

void WaveformGenerator::onBufferReady() {
    QAudioBuffer buf = m_decoder->read();
    if (!buf.isValid()) return;

    const float *data = buf.constData<float>();
    int count = buf.frameCount();

    // Peak per 64-frame chunk
    constexpr int CHUNK = 64;
    for (int i = 0; i < count; i += CHUNK) {
        float peak = 0.0f;
        int end = qMin(i + CHUNK, count);
        for (int j = i; j < end; ++j)
            peak = qMax(peak, qAbs(data[j]));
        m_rawPeaks.append(peak);
    }
    m_totalFrames += count;
}

void WaveformGenerator::onFinished() {
    buildEnvelope();
    m_loading = false;
    m_ready = true;
    emit loadingChanged();
    emit readyChanged();
    emit samplesChanged();
}

void WaveformGenerator::onDecoderError(QAudioDecoder::Error error) {
    Q_UNUSED(error)
    m_loading = false;
    m_ready = false;
    emit loadingChanged();
    emit readyChanged();
}

// Downsample raw peaks into RESOLUTION buckets, normalize 0–1
void WaveformGenerator::buildEnvelope() {
    m_samples.clear();
    if (m_rawPeaks.isEmpty()) {
        m_samples.fill(0.0, RESOLUTION);
        return;
    }

    int rawCount = m_rawPeaks.size();
    m_samples.reserve(RESOLUTION);

    for (int i = 0; i < RESOLUTION; ++i) {
        int start = (i * rawCount) / RESOLUTION;
        int end   = ((i + 1) * rawCount) / RESOLUTION;
        end = qMax(end, start + 1);

        float peak = 0.0f;
        for (int j = start; j < qMin(end, rawCount); ++j)
            peak = qMax(peak, m_rawPeaks[j]);
        m_samples.append(static_cast<qreal>(peak));
    }

    qreal maxVal = *std::max_element(m_samples.begin(), m_samples.end());
    if (maxVal > 0.001) {
        for (auto &s : m_samples)
            s /= maxVal;
    }
}
