-- Stream Alerts {{{

-- DROP TABLE IF EXISTS stream_alerts;
-- DROP TABLE IF EXISTS streams;
-- DROP TABLE IF EXISTS alert_channels;
-- DROP TABLE IF EXISTS streamers;

CREATE TABLE streamers(
  userid BIGINT PRIMARY KEY,
  login_name TEXT NOT NULL,
  display_name TEXT NOT NULL
);

CREATE TABLE alert_channels(
  subscriptionid SERIAL PRIMARY KEY,
  guildid BIGINT NOT NULL,
  channelid BIGINT NOT NULL,
  streamerid BIGINT NOT NULL REFERENCES streamers (userid) ON DELETE CASCADE,
  created_by BIGINT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  paused BOOLEAN NOT NULL DEFAULT FALSE,
  end_delete BOOLEAN NOT NULL DEFAULT FALSE,
  live_message TEXT,
  end_message TEXT
);
CREATE INDEX alert_channels_guilds ON alert_channels (guildid);
CREATE UNIQUE INDEX alert_channels_channelid_streamerid ON alert_channels (channelid, streamerid);

CREATE TABLE streams(
  streamid SERIAL PRIMARY KEY,
  streamerid BIGINT NOT NULL REFERENCES streamers (userid) ON DELETE CASCADE,
  start_at TIMESTAMPTZ NOT NULL,
  twitch_stream_id BIGINT,
  game_name TEXT,
  title TEXT,
  end_at TIMESTAMPTZ
);

CREATE TABLE stream_alerts(
    alertid SERIAL PRIMARY KEY,
    streamid INTEGER NOT NULL REFERENCES streams (streamid) ON DELETE CASCADE,
    subscriptionid INTEGER NOT NULL REFERENCES alert_channels (subscriptionid) ON DELETE CASCADE,
    sent_at TIMESTAMPTZ NOT NULL,
    messageid BIGINT NOT NULL,
    resolved_at TIMESTAMPTZ
);


-- }}}

