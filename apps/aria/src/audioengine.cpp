#include "audioengine.h"

AudioEngine::AudioEngine(QObject *parent)
    : QObject(parent)
    , m_player(new QMediaPlayer(this))
    , m_output(new QAudioOutput(this))
{
    m_player->setAudioOutput(m_output);
    m_output->setVolume(0.75f);

    // Forward position/duration directly — no intermediate state needed
    connect(m_player, &QMediaPlayer::positionChanged, this, &AudioEngine::positionChanged);
    connect(m_player, &QMediaPlayer::durationChanged, this, &AudioEngine::durationChanged);

    // Playback state → single playingChanged signal
    connect(m_player, &QMediaPlayer::playbackStateChanged, this, [this]() {
        emit playingChanged();
    });

    // Media status transitions
    connect(m_player, &QMediaPlayer::mediaStatusChanged, this, [this](QMediaPlayer::MediaStatus s) {
        if (s == QMediaPlayer::LoadedMedia)  emit mediaLoaded();
        if (s == QMediaPlayer::EndOfMedia)   emit endOfMedia();
    });

    // Error forwarding
    connect(m_player, &QMediaPlayer::errorOccurred, this,
        [this](QMediaPlayer::Error, const QString &msg) { emit errorOccurred(msg); });
}

// ── Property accessors ──────────────────────────────────────

QUrl AudioEngine::source() const { return m_player->source(); }

void AudioEngine::setSource(const QUrl &url) {
    if (m_player->source() != url) {
        m_player->setSource(url);
        emit sourceChanged();
    }
}

qint64 AudioEngine::position() const { return m_player->position(); }
void   AudioEngine::setPosition(qint64 ms) { m_player->setPosition(ms); }
qint64 AudioEngine::duration() const { return m_player->duration(); }

qreal AudioEngine::volume() const { return m_output->volume(); }
void  AudioEngine::setVolume(qreal v) {
    float fv = qBound(0.0f, static_cast<float>(v), 1.0f);
    if (!qFuzzyCompare(m_output->volume(), fv)) {
        m_output->setVolume(fv);
        emit volumeChanged();
    }
}

bool AudioEngine::playing() const {
    return m_player->playbackState() == QMediaPlayer::PlayingState;
}

bool AudioEngine::muted() const { return m_output->isMuted(); }
void AudioEngine::setMuted(bool m) {
    if (m_output->isMuted() != m) {
        m_output->setMuted(m);
        emit mutedChanged();
    }
}

// ── Playback control ────────────────────────────────────────

void AudioEngine::play()  { m_player->play(); }
void AudioEngine::pause() { m_player->pause(); }
void AudioEngine::stop()  { m_player->stop(); }

void AudioEngine::togglePlayPause() {
    playing() ? pause() : play();
}

void AudioEngine::seek(qreal ratio) {
    if (m_player->duration() > 0)
        setPosition(static_cast<qint64>(qBound(0.0, ratio, 1.0) * m_player->duration()));
}

void AudioEngine::seekForward(int ms) {
    setPosition(qMin(position() + ms, duration()));
}

void AudioEngine::seekBackward(int ms) {
    setPosition(qMax(position() - ms, qint64(0)));
}
