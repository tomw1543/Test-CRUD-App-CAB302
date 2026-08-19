-- V2__add_favourite_colour.sql
-- Harmless test migration: adds a nullable column to verify the migration
-- pipeline correctly picks up and applies new versioned files.

ALTER TABLE Users ADD COLUMN FavouriteColour TEXT;