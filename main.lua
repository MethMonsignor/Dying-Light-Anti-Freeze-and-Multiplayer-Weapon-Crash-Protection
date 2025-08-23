-- EmporiumRP Watchdog Bootstrap
-- Author: MethMonsignor

-- Load freeze and weapon crash guard
dofile("scripts/init_watchdog.lua")

-- Optional: simulate frame updates if no native loop exists
function Update()
    onFrameUpdate()
end

-- Optional: simulate weapon spawn for testing
function SpawnTestWeapon()
    local testWeapon = {
        damage = 9999999,
        effects = {"fire", "invalid_effect", "electric"}
    }
    onWeaponSpawn(testWeapon)
end

-- Trigger test logic
SpawnTestWeapon()
Update()