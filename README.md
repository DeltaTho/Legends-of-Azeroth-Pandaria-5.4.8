# Mists of Pandaria 5.4.8 with playerbots: Cataclysm-era quest repairs

This fork predominantly tracks
[1LineAtaTime's LoA-Pandaria-Playerbots](https://github.com/1LineAtaTime/LoA-Pandaria-Playerbots)
(branch `playerbot-beta`), a Mists of Pandaria 5.4.8 (build 18414) server core with a full
playerbots module, itself built on the
[Legends of Azeroth Pandaria 5.4.8](https://github.com/Legends-of-Azeroth/Legends-of-Azeroth-Pandaria-5.4.8)
core. For what the core and the playerbots do, and for how to build, install and configure the
server, see that repository's README. See [THANKS](THANKS.md) for the authors and contributors
of the core.

## Goal of this fork

The goal of this fork is to implement the Cataclysm-era quests of the old world one region at
a time.   Many of the commits include references that were used to validate, such as online data
sniffs, other cores, video evidence, or retail references.

The first pass is being developed and tested from the Horde's perspective, and later follow-up
passes will be required to test and validate the alliance's perspective.

## Regions worked so far

| Region | Status |
|---|---|
| Tirisfal Glades | Merged into `playerbot-beta` |
| Silverpine Forest | Merged into `playerbot-beta` |
| Hillsbrad Foothills | Merged into `playerbot-beta` |
| Arathi Highlands | Merged into `playerbot-beta` |
| The Hinterlands | Merged into `playerbot-beta` |
| Western Plaguelands | On [`pr/western-plaguelands`](../../tree/pr/western-plaguelands), not merged yet |

## Branches

- `main`: `playerbot-beta` plus everything of this fork that is not merged there yet. It is
  rebuilt on top of `playerbot-beta` whenever that branch takes our work, so its history is
  rewritten from time to time.
- `fixes`: general fixes outside the region work that are not in `playerbot-beta` yet.
- `pr/western-plaguelands`: the Western Plaguelands set.

Branches of regions that have been merged are removed.
