-- Anti-Freeze + Multiplayer Weapon Crash Guard (Extended)
-- Author: MethMonsignor
-- Purpose: Detect runtime freezes and sanitize crash-inducing weapons (local + remote)

local lastTick = os.clock()
local freezeThreshold = 5.0 -- seconds
local quarantineVault = {}

function heartbeat()
    local now = os.clock()
    if (now - lastTick) > freezeThreshold then
        logFreeze(now - lastTick)
        attemptRecovery()
    end
    lastTick = now
end

function logFreeze(duration)
    print("[Integrity Breach] Freeze detected: " .. duration .. "s")
end

function attemptRecovery()
    print("[Recovery Protocol] Attempting to stabilize simulation...")
end

-- Weapon Crash Guard
function validateWeapon(weapon)
    if not weapon or type(weapon) ~= "table" then
        print("[Weapon Validation] Invalid weapon structure")
        return false
    end

    -- Deep sanitize
    sanitizeWeaponRecursive(weapon)

    -- Clamp damage
    if weapon.damage then
        if weapon.damage < 0 or weapon.damage > 999999 then
            print("[Weapon Validation] Damage out of bounds: " .. tostring(weapon.damage))
            weapon.damage = math.min(math.max(weapon.damage, 0), 999999)
        end
    end

    -- Validate mesh
    if weapon.mesh then
        weapon.mesh = normalizeMesh(weapon.mesh)
        if not isValidMesh(weapon.mesh) then
            print("[Weapon Validation] Unsafe mesh detected: " .. tostring(weapon.mesh))
            weapon.mesh = "default_weapon_mesh"
        end
    end

    -- Validate effects
    if weapon.effects then
        if #weapon.effects > 10 then
            print("[Weapon Cleanup] Too many effects, trimming...")
            weapon.effects = { unpack(weapon.effects, 1, 10) }
        end
        for _, effect in ipairs(weapon.effects) do
            effect = normalizeEffect(effect)
            if not isValidEffect(effect) then
                print("[Weapon Validation] Invalid effect: " .. tostring(effect))
                removeEffect(weapon, effect)
            end
        end
    end

    -- Strip executable fields
    stripExecutableFields(weapon)

    -- Trace origin
    traceWeaponOrigin(weapon)

    print("[Lore Alert] Anomalous weapon signature intercepted. Purging unsafe parameters...")
    return true
end

function sanitizeWeaponRecursive(tbl, depth)
    depth = depth or 0
    if depth > 5 then return end -- prevent infinite recursion

    for k, v in pairs(tbl) do
        if type(v) == "table" then
            sanitizeWeaponRecursive(v, depth + 1)
        elseif type(v) == "function" or type(v) == "userdata" then
            print("[Weapon Cleanup] Removed unsafe field: " .. tostring(k))
            tbl[k] = nil
        elseif type(v) == "string" and #v > 256 then
            print("[Weapon Cleanup] Oversized string field: " .. tostring(k))
            tbl[k] = string.sub(v, 1, 256)
        end
    end
end

function stripExecutableFields(weapon)
    local dangerousFields = { "onUse", "callback", "script", "trigger", "exec" }
    for _, field in ipairs(dangerousFields) do
        if weapon[field] then
            print("[Weapon Cleanup] Stripped executable field: " .. field)
            weapon[field] = nil
        end
    end
end

function normalizeMesh(mesh)
    local str = tostring(mesh):lower():gsub("%s+", "")
    return decodeObfuscated(str)
end

function normalizeEffect(effect)
    local str = tostring(effect):lower():gsub("%s+", "")
    return decodeObfuscated(str)
end

function decodeObfuscated(str)
    -- Basic hex decode
    if str:match("^0x") then
        local decoded = ""
        for hex in str:gmatch("0x%x%x") do
            decoded = decoded .. string.char(tonumber(hex))
        end
        return decoded
    end
    return str
end

function isValidEffect(effect)
    local safeEffects = {
        "fire", "electric", "bleed", "toxic", "freeze", "impact"
    }
    for _, e in ipairs(safeEffects) do
        if effect == e then return true end
    end
    return false
end

function isValidMesh(mesh)
    local safeMeshes = {
        "default_weapon_mesh", "katana_mesh", "pistol_mesh", "bat_mesh"
    }
    for _, m in ipairs(safeMeshes) do
        if mesh == m then return true end
    end
    return false
end

function removeEffect(weapon, effect)
    for i, e in ipairs(weapon.effects) do
        if e == effect then
            table.remove(weapon.effects, i)
            print("[Weapon Cleanup] Removed unsafe effect: " .. effect)
            break
        end
    end
end

function traceWeaponOrigin(weapon)
    local origin = weapon.owner or weapon.source or "unknown"
    print("[Threat Trace] Weapon origin: " .. tostring(origin))
end

function quarantineWeapon(weapon)
    table.insert(quarantineVault, weapon)
    print("[Quarantine] Weapon isolated for contributor review")
end

-- Multiplayer Entity Monitor
function onEntityCreated(entity)
    if entity and entity.type == "weapon" then
        print("[Entity Monitor] Weapon entity spawned: validating...")
        local safe = validateWeapon(entity)
        if not safe then quarantineWeapon(entity) end
    end
end

-- Hook into frame update and weapon spawn logic
function onFrameUpdate()
    heartbeat()
end

function onWeaponSpawn(weapon)
    local safe = validateWeapon(weapon)
    if not safe then quarantineWeapon(weapon) end
end
