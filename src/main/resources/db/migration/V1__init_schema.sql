-- =====================================================================
-- Event Platform Database Schema (SQLite)

-- =====================================================================



DROP TABLE IF EXISTS UserEvents;
DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Source;

-- ---------------------------------------------------------------------
-- Source: where an event listing was pulled from (partner site, feed)
-- ---------------------------------------------------------------------
CREATE TABLE Source (
                        SourceID    INTEGER PRIMARY KEY AUTOINCREMENT,
                        SiteName    TEXT    NOT NULL,
                        SiteURL     TEXT    NOT NULL
);

-- ---------------------------------------------------------------------
-- Users
-- ---------------------------------------------------------------------
CREATE TABLE Users (
                       UserID          INTEGER PRIMARY KEY AUTOINCREMENT,
                       FirstName       TEXT     NOT NULL,
                       LastName        TEXT     NOT NULL,
                       Email           TEXT     NOT NULL UNIQUE,
                       PasswordHash    TEXT     NOT NULL,
                       HomeLat         REAL,
                       HomeLong        REAL,
                       DateCreated     DATE     NOT NULL DEFAULT (date('now')),
                       IsActive        INTEGER  NOT NULL DEFAULT 1 CHECK (IsActive IN (0, 1))
);

-- ---------------------------------------------------------------------
-- Events
-- Relationship: Source (1) ----- (1..*) Events
-- ---------------------------------------------------------------------
CREATE TABLE Events (
                        EventID         INTEGER PRIMARY KEY AUTOINCREMENT,
                        Title           TEXT     NOT NULL,
                        Description     TEXT,
                        Category        TEXT, -- is a text type for now incase we think of anymore catagories to add may want to add a CHECK to restrict values
                        StartTime       DATETIME NOT NULL,
                        EndTime         DATETIME,
                        VenueName       TEXT,
                        Address         TEXT,
                        EventLat        REAL,
                        EventLng        REAL,
                        ImageURL        TEXT,
                        CreatedAt       DATETIME NOT NULL DEFAULT (datetime('now')),
                        HasOccured      INTEGER  NOT NULL DEFAULT 0 CHECK (HasOccured IN (0, 1)),
                        SourceID        INTEGER  NOT NULL,
                        LikesCount      INTEGER  NOT NULL DEFAULT 0,
                        CommentsCount   INTEGER  NOT NULL DEFAULT 0,
                        FOREIGN KEY (SourceID) REFERENCES Source (SourceID)
                            ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_events_sourceid ON Events (SourceID);

-- ---------------------------------------------------------------------
-- Comments
-- Relationships: Events (1) ----- (0..*) Comments
--                Users  (1) ----- (0..*) Comments
-- ---------------------------------------------------------------------
CREATE TABLE Comments (
                          CommentID   INTEGER  PRIMARY KEY AUTOINCREMENT,
                          UserID      INTEGER  NOT NULL,
                          EventsID    INTEGER  NOT NULL,
                          CreatedAt   DATETIME NOT NULL DEFAULT (datetime('now')),
                          Content     TEXT     NOT NULL,
                          UpdatedAt   DATETIME,
                          FOREIGN KEY (UserID) REFERENCES Users (UserID)
                              ON DELETE CASCADE ON UPDATE CASCADE,
                          FOREIGN KEY (EventsID) REFERENCES Events (EventID)
                              ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_comments_userid   ON Comments (UserID);
CREATE INDEX idx_comments_eventsid ON Comments (EventsID);

-- ---------------------------------------------------------------------
-- Likes
-- Relationships: Events (1) ----- (0..*) Likes
--                Users  (1) ----- (0..*) Likes
-- ---------------------------------------------------------------------
CREATE TABLE Likes (
                       LikeID      INTEGER  PRIMARY KEY AUTOINCREMENT,
                       UserID      INTEGER  NOT NULL,
                       EventsID    INTEGER  NOT NULL,
                       CreatedAt   DATETIME NOT NULL DEFAULT (datetime('now')),
                       FOREIGN KEY (UserID) REFERENCES Users (UserID)
                           ON DELETE CASCADE ON UPDATE CASCADE,
                       FOREIGN KEY (EventsID) REFERENCES Events (EventID)
                           ON DELETE CASCADE ON UPDATE CASCADE,
                       UNIQUE (UserID, EventsID)
);

CREATE INDEX idx_likes_userid   ON Likes (UserID);
CREATE INDEX idx_likes_eventsid ON Likes (EventsID);

-- ---------------------------------------------------------------------
-- UserEvents: join table tracking a user's subscription/RSVP status
-- for an event, with optional pointers to a related like/comment.
-- Relationships: Events (1) ----- (0..*) UserEvents
--                Users  (1) ----- (0..*) UserEvents
-- ---------------------------------------------------------------------
CREATE TABLE UserEvents (
                            UserID          INTEGER  NOT NULL,
                            EventID         INTEGER  NOT NULL,
                            Status          TEXT, -- also not enforced with enum values so we can add new ones then finilise at the end of the project
                            DateSubscribed  DATE     NOT NULL DEFAULT (date('now')),
                            PRIMARY KEY (UserID, EventID),
                            FOREIGN KEY (UserID) REFERENCES Users (UserID)
                                ON DELETE CASCADE ON UPDATE CASCADE,
                            FOREIGN KEY (EventID) REFERENCES Events (EventID)
                                ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_userevents_eventid    ON UserEvents (EventID);


-- =====================================================================
-- TRIGGER: triggers to keep Events.LikesCount / CommentsCount in
-- sync automatically.
-- =====================================================================
CREATE TRIGGER trg_likes_count_after_insert
    AFTER INSERT ON Likes
BEGIN
    UPDATE Events SET LikesCount = LikesCount + 1 WHERE EventID = NEW.EventsID;
END;

CREATE TRIGGER trg_likes_count_after_delete
    AFTER DELETE ON Likes
BEGIN
    UPDATE Events SET LikesCount = LikesCount - 1 WHERE EventID = OLD.EventsID;
END;

CREATE TRIGGER trg_comments_count_after_insert
    AFTER INSERT ON Comments
BEGIN
    UPDATE Events SET CommentsCount = CommentsCount + 1 WHERE EventID = NEW.EventsID;
END;

CREATE TRIGGER trg_comments_count_after_delete
    AFTER DELETE ON Comments
BEGIN
    UPDATE Events SET CommentsCount = CommentsCount - 1 WHERE EventID = OLD.EventsID;
END;