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
| Western Plaguelands | Merged into `playerbot-beta` |
| Eastern Plaguelands | Merged into `playerbot-beta` |
| Badlands | On [`pr/badlands`](../../tree/pr/badlands), not merged yet |
| Searing Gorge | On [`pr/searing-gorge`](../../tree/pr/searing-gorge), not merged yet |
| Burning Steppes | On [`pr/burning-steppes`](../../tree/pr/burning-steppes), not merged yet |
| Swamp of Sorrows | On [`pr/swamp-of-sorrows`](../../tree/pr/swamp-of-sorrows), not merged yet |
| Blasted Lands | On [`pr/blasted-lands`](../../tree/pr/blasted-lands), not merged yet |
| Durotar, with the Valley of Trials and the Echo Isles (orc and troll starting zones) | On [`pr/durotar`](../../tree/pr/durotar), not merged yet |

## Branches

- `main`: `playerbot-beta` plus everything of this fork that is not merged there yet. It is
  rebuilt on top of `playerbot-beta` whenever that branch takes our work, so its history is
  rewritten from time to time.
- `fixes`: general fixes outside the region work that are not in `playerbot-beta` yet.
- `pr/badlands`: the Badlands set.
- `pr/searing-gorge`: the Searing Gorge set, on top of `pr/badlands` (both add to the same
  script lists).
- `pr/burning-steppes`: the Burning Steppes set, on top of `pr/searing-gorge`.
- `pr/swamp-of-sorrows`: the Swamp of Sorrows set, on top of `pr/burning-steppes`.
- `pr/blasted-lands`: the Blasted Lands set, on top of `pr/swamp-of-sorrows`.
- `pr/durotar`: the Durotar set, with the Valley of Trials and the Echo Isles, on top of
  `pr/blasted-lands`. It also carries the breadcrumb-quest core support from `fixes`, which its
  quests need.

Branches of regions that have been merged are removed.
