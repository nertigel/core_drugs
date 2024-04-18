# Modified core_drugs
With config and image files for ox_inventory. 
It was sitting in one of my server files and I felt like sharing it with others since I have no use in it.
All credits go to the origianl `core_drugs`.

I added some strains that I know of with real flower images. And I also added THC and CBD levels which determine the price of the weed when it's sold to the dealers across the map. 
Every plant may have it's own THC/CBD values which can be edited in `config.lua`

Algorithm on how price is determined can be found on line 146 in `server/main.lua`.

### All existing strains
- Bubba Kush T22/C3
- Lemon Haze T20/C1
- Wedding Cake T24/C2
- White Widow T25/C3
- Miracle Cookies (MAC) T25/C3
- Hindu Kush T25/C2
- Do Si Dos T27/C3
- Gorilla Glue 4 T27/C4

# Requirements
- es_extended
- ox_inventory
- ox_target
- just_apartments (Optional)

# just_apartments integration
We can add a check for indoor and outdoor plants with this, for now all it does is let you plant indoor even if you're not standing on dirt/grass.

On line 608 (`just_apartments/client.lua/just_apartments:enterExitApartment` handler):

```lua
if coords.enteringExiting == "Entering" then
  TriggerEvent("nertigel_drugs:is_player_indoor", true)
elseif coords.enteringExiting == "Exiting" then
  TriggerEvent("nertigel_drugs:is_player_indoor", false)
end
```

# Errors
The resource requires some changes, there are "token" protections and some more adaptations to make the resource run better.
Make sure not to rename the folder from `core_drugs` because it might causes issues with html/js.
