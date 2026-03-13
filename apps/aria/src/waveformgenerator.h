#ifndef WAVEFORMGENERATOR_H
#define WAVEFORMGENERATOR_H

#include <QObject>
#include <QUrl>
#include <QVector>
#include <QAudioDecoder>

// Decodes audio and produces a normalized amplitude envelope.
// Uses QAudioDecoder (async, runs on Qt's internal thread pool).
// Stores high-res samples (RESOLUTION); QML downsamples at paint time.
class WaveformGenerator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl source           READ source   WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QList<qreal> samples  READ samples  NOTIFY samplesChanged)
    Q_PROPERTY(bool loading          READ loading   NOTIFY loadingChanged)
    Q_PROPERTY(bool ready            READ ready     NOTIFY readyChanged)

public:
    // Internal resolution — high enough for any display width
    static constexpr int RESOLUTION = 512;

    explicit WaveformGenerator(QObject *parent = nullptr);

    QUrl source() const;
    void setSource(const QUrl &url);
    QList<qreal> samples() const;
    bool loading() const;
    bool ready() const;

signals:
    void sourceChanged();
    void samplesChanged();
    void loadingChanged();
    void readyChanged();

private:
    void startDecode();
    void onBufferReady();
    void onFinished();
    void onDecoderError(QAudioDecoder::Error error);
    void buildEnvelope();

    QUrl             m_source;
    QList<qreal>     m_samples;      // normalized 0–1, length = RESOLUTION
    bool             m_loading = false;
    bool             m_ready   = false;
    QAudioDecoder   *m_decoder = nullptr;
    QVector<float>   m_rawPeaks;     // accumulates peak per chunk
    qint64           m_totalFrames = 0;
};

#endif // WAVEFORMGENERATOR_H
