#ifndef AUDIOENGINE_H
#define AUDIOENGINE_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QUrl>

// Thin wrapper around QMediaPlayer + QAudioOutput.
// Exposes a clean QML-friendly API for playback control.
class AudioEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl    source   READ source   WRITE setSource   NOTIFY sourceChanged)
    Q_PROPERTY(qint64  position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(qint64  duration READ duration                   NOTIFY durationChanged)
    Q_PROPERTY(qreal   volume   READ volume   WRITE setVolume   NOTIFY volumeChanged)
    Q_PROPERTY(bool    playing  READ playing                    NOTIFY playingChanged)
    Q_PROPERTY(bool    muted    READ muted    WRITE setMuted    NOTIFY mutedChanged)

public:
    explicit AudioEngine(QObject *parent = nullptr);

    QUrl   source()   const;
    void   setSource(const QUrl &url);
    qint64 position() const;
    void   setPosition(qint64 ms);
    qint64 duration() const;
    qreal  volume()   const;
    void   setVolume(qreal v);
    bool   playing()  const;
    bool   muted()    const;
    void   setMuted(bool m);

    // QML-callable slots
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void seek(qreal ratio);        // 0.0–1.0
    Q_INVOKABLE void seekForward(int ms = 5000);
    Q_INVOKABLE void seekBackward(int ms = 5000);

signals:
    void sourceChanged();
    void positionChanged();
    void durationChanged();
    void volumeChanged();
    void playingChanged();
    void mutedChanged();
    void mediaLoaded();
    void endOfMedia();
    void errorOccurred(const QString &error);

private:
    QMediaPlayer *m_player;
    QAudioOutput *m_output;
};

#endif // AUDIOENGINE_H
