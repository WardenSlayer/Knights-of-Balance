require 'herorealms'
require 'decks'
require 'stdlib'
require 'timeoutai'
require 'hardai_2'
require 'aggressiveai'

local debug_mode = false
local test_monk = false
local test_cleric = false
local test_bard = false
function get_debug_cards(is_p1)
    player_buffs = is_p1 and {
        drawCardsCountAtTurnEndDef(5),
        discardCardsAtTurnStartDef(),
        replace_spring_blossom_buff(),
        replace_bard_dagger_buff(),
        replace_necromancer_dagger_buff(),
        end_of_turn_toughness_converter_buff(),
        fatigueCount(40, 1, "FatigueP1"),
    } or {
        drawCardsCountAtTurnEndDef(5),
        discardCardsAtTurnStartDef(),
        end_of_turn_toughness_converter_buff(),
        fatigueCount(40, 1, "FatigueP2"),
    } 
    if test_monk then
        return {
            reserve = {
                { qty = 1, card = monk_horn_of_ascendance_carddef() },
            },
            deck = {
                { qty = 4, card = monk_spring_blossom_carddef() },
            },
            hand = {
                { qty = 1, card = monk_horn_of_ascendance_carddef() },
                { qty = 6, card = monk_spring_blossom_carddef() },
                { qty = 2, card = monk_cobra_fang_carddef() },
            },
            discard = {
                { qty = 2, card = monk_spring_blossom_carddef() },
            },
            skills = {
                { qty = 1, card = monk_wraps_of_strength_carddef() },
            },
            buffs = player_buffs
        }
    elseif test_cleric then
        return {
            reserve = {
                { qty = 1, card = cleric_enduring_follower_carddef() },
            },
            deck = {
                { qty = 4, card = cleric_everburning_candle_carddef() },
                 { qty = 2, card = cleric_prayer_beads_carddef() },
            },
            hand = {
                { qty = 1, card = cleric_everburning_candle_carddef() },
                { qty = 1, card = cleric_prayer_beads_carddef()},
                { qty = 1, card = cleric_imperial_sailor_carddef() },
            },
            discard = {
                 { qty = 2, card = cleric_imperial_sailor_carddef() },
                 { qty = 1, card = cleric_enduring_follower_carddef() },
                 { qty = 1, card = cleric_follower_b_carddef() }              
            },
            skills = {
                --{ qty = 1, card = cleric_shining_breastplate_carddef() },
            },
            buffs = player_buffs
        }
    elseif test_bard then
        return {
            reserve = {
            },
            deck = {
                { qty = 1, card = dagger_carddef()}
            },
            hand = {
                { qty = 1, card = bard_necros_dirge_carddef() },
                { qty = 1, card = bard_dancing_blade_carddef() },
            },
            discard = {
            },
            skills = {
                { qty = 1, card = bard_collecting_cap_carddef() },
            },
            buffs = player_buffs
        }
    else
        return {
            reserve = {
                { qty = 1, card = wizard_treasure_map_carddef() },
                { qty = 1, card = ranger_parrot_carddef() },
                { qty = 1, card = monk_horn_of_ascendance_carddef() }

            },
            deck = {
                { qty = 1, card = dagger_carddef() },
                { qty = 1, card = necromancer_bloodrose_carddef() },
            },
            hand = {
                { qty = 1, card = thief_blinding_powder_carddef() },
                { qty = 1, card = monk_horn_of_ascendance_carddef() },
                { qty = 1, card = thief_enchanted_garrote_carddef() },
                { qty = 1, card = ranger_light_crossbow_carddef() },
                { qty = 1, card = ranger_honed_black_arrow_carddef() },
                { qty = 2, card = cleric_follower_b_carddef() },
                { qty = 2, card = cleric_imperial_sailor_carddef() },
                { qty = 1, card = cleric_brightstar_shield_carddef() },
                { qty = 1, card = cleric_everburning_candle_carddef() },
                { qty = 1, card = sway_carddef() },
            },
            discard = {
                { qty = 2, card = cleric_follower_b_carddef() },
                { qty = 1, card = cleric_follower_b_carddef() },
            },
            skills = {
                { qty = 1, card = cleric_shining_breastplate_carddef() },
                { qty = 1, card = druid_grass_weave_sash_carddef() },
            },
            buffs = player_buffs
        }
    end
end
-- Game Setup
--=======================================================================================================
function setupGame(g)
    registerCards(g, {
        toughness_token_carddef(),
    })

    standardSetup(g, {
        description = "Knights of  Balance: A Community Game Balancing Effort.",
        playerOrder = { plid1, plid2 },
        ai = ai.CreateKillSwitchAi(createAggressiveAI(),  createHardAi2()),
        timeoutAi = createTimeoutAi(),
        opponents = { { plid1, plid2 } },
        players = {
            {
                id = plid1,
                --isAi = true,
                startDraw = 3,
                init = {
                    fromEnv = plid1
                },
                cards = debug_mode and get_debug_cards(true) or {
                    buffs = {
                        drawCardsCountAtTurnEndDef(5),
                        discardCardsAtTurnStartDef(),
                        replace_spring_blossom_buff(),
                        replace_bard_dagger_buff(),
                        replace_necromancer_dagger_buff(),
                        end_of_turn_toughness_converter_buff(),
                        fatigueCount(40, 1, "FatigueP1"),
                    }
                }
            },
            {
                id = plid2,
                isAi = debug_mode,
                startDraw = 5,
                init = {
                    fromEnv = plid2
                },
                cards = debug_mode and get_debug_cards(false) or {
                    buffs = {
                        end_of_turn_toughness_converter_buff(),
                        drawCardsCountAtTurnEndDef(5),
                        discardCardsAtTurnStartDef(),
                        fatigueCount(40, 1, "FatigueP2"),
                    }
                }
            },            
        }
    })
end

function endGame(g)
end

function setupMeta(meta)
                meta.name = "knights_of_balance_beta"
                meta.minLevel = 13
                meta.maxLevel = 24
                meta.introbackground = ""
                meta.introheader = ""
                meta.introdescription = ""
                meta.path = "C:/Users/xTheC/Desktop/Git Repositories/Knights-of-Balance/Knights of Balance/knights_of_balance_beta.lua"
                meta.features = {
}

end

--Card Overrides
--=======================================================================================================
--
--Fighter
--=======================================================================================================
function fighter_rallying_flag_carddef()
    local cardLayout = createLayout({
        name = "Rallying Flag",
        art = "art/t_fighter_rallying_flag",
        frame = "frames/Warrior_CardFrame",
        cardTypeLabel = "Champion",
        isGuard = true,
        health = 1,
        types = { championType, humanType, fighterType },
        xmlText = [[<vlayout>
                        <box flexibleheight="1">
                            <tmpro text="{gold_1}   {combat_1}" fontsize="60"/>
                        </box>
                    </vlayout>]]
    })
    return createChampionDef({
        id = "fighter_rallying_flag",
        name = "Rallying Flag",
        acquireCost = 0,
        health = 1,
        isGuard = true,
        layout = cardLayout,
        types = { championType, humanType, fighterType },
        factions = {},
        abilities = {
            createAbility({
                id = "fighter_rallying_flag",
                trigger = autoTrigger,
                activations = multipleActivations,
                cost = expendCost,
                effect = gainCombatEffect(1).seq(gainGoldEffect(1))
            }),
        }
    })
end
--=========================================
function fighter_helm_of_fury_carddef()
    local cardLayout = createLayout({
        name = "Helm of Fury",
        art = "art/t_fighter_helm_of_fury",
        frame = "frames/Warrior_CardFrame",
        cardTypeLabel = "Magical Armor",
        xmlText =[[<vlayout>
                        <hlayout flexibleheight="1">
                            <box flexiblewidth="1">
                                <tmpro text="{requiresHealth_20}" fontsize="72"/>
                            </box>
                            <box flexiblewidth="7">
                                <tmpro text="If you have a guard in play,&lt;br&gt; gain {gold_1} {combat_1}" fontsize="32" />
                            </box>
                        </hlayout>
                </vlayout>
                    ]]
    })
    local guardChamps = selectLoc(loc(currentPid, inPlayPloc)).where(isGuard()).count()
    local disableHelm = disableTarget({ endOfTurnExpiry }).apply(selectLoc(loc(currentPid, skillsPloc)).where(isCardType(magicArmorType)))
    --local disableHelm = nullEffect()
    --
    return createMagicArmorDef({
        id = "fighter_helm_of_fury",
        name = "Helm of Fury",
        types = {fighterType, magicArmorType, treasureType, headType},
        layout = cardLayout,
        layoutPath = "icons/fighter_helm_of_fury",
        abilities = {
                createAbility({
                    id = "helmGuard",
                    trigger = autoTrigger,
                    check = minHealthCurrent(20).And(guardChamps.gte(1)),
                    effect = gainCombatEffect(1).seq(gainGoldEffect(1)).seq(disableHelm)
                }),
                createAbility({
                    id = "helmLateGuard",
                    trigger = onPlayTrigger,
                    activations = singleActivation,
                    check = minHealthCurrent(20),
                    effect = ifElseEffect(guardChamps.gte(1),
                                            gainCombatEffect(1).seq(gainGoldEffect(1)).seq(disableHelm),
                                            nullEffect()) 
                }),
                createAbility({
                    id = "helmHeal",
                    trigger = gainedHealthTrigger,
                    activations = singleActivation,
                    check = minHealthCurrent(20),
                    effect = ifElseEffect(guardChamps.gte(1),
                                            gainCombatEffect(1).seq(gainGoldEffect(1)).seq(disableHelm),
                                            nullEffect()) 
                })
        }        
    })
end

--Wizard
--=======================================================================================================


--Ranger
--=======================================================================================================
function ranger_honed_black_arrow_carddef()
    local cardLayout = createLayout({
        name = "Honed Black Arrow",
        art = "art/t_ranger_honed_black_arrow",
        frame = "frames/Ranger_CardFrame",
        cardTypeLabel = "Item",
        xmlText =[[<vlayout>
                    <hlayout flexibleheight="2">
                            <tmpro text="&lt;space=-0.3em/&gt;{combat_4}" fontsize="60" flexiblewidth="8" />
                    </hlayout>
                    <hlayout flexibleheight="3">
                            <tmpro text="If you have a bow in play, Draw a card." fontsize="28" flexiblewidth="1" />
                    </hlayout>
                </vlayout>]]
    })
    --
    local bowInPlay = selectLoc(loc(currentPid, castPloc)).where(isCardType(bowType)).count()
    --
    return createItemDef({
        id = "ranger_honed_black_arrow",
        name = "Honed Black Arrow",
        acquireCost = 0,
        cardTypeLabel = "Item",
        types = { itemType, noStealType, rangerType, arrowType},
        factions = {},
        layout = cardLayout,
        playLocation = castPloc,
            abilities = {
                createAbility({
					id = "ranger_honed_black_arrow_combat",
					effect =gainCombatEffect(4),
					cost = noCost,
					trigger = onPlayTrigger,
					playAllType = noPlayPlayType,
					tags = { gainCombatTag ,aiPlayAllTag }
				}),
                createAbility({
					id = "ranger_honed_black_arrow_draw",
					effect = drawCardsWithAnimation(1),
					cost = noCost,
					trigger = autoTrigger,
					activations = singleActivation,
					check = selectLoc(currentInPlayLoc).union(selectLoc(currentCastLoc)).where(isCardType(bowType)).count().gte(1),
					tags = { draw1Tag },
					aiPriority = ifInt(
						selectLoc(currentInPlayLoc).
						union(selectLoc(currentCastLoc)).
						where(isCardType(bowType)).count().gte(1), toIntExpression(300), toIntExpression(-1))
				})
                },
    })
end

--Bard
--=======================================================================================================

-- Bard collecting cap is a 20 Health Threshold magic armor. 
-- Activate: +1 gold OR +3 healing if you have a song in play.
function bard_collecting_cap_carddef()
    local cardLayout = createLayout({
        name = "Collecting Cap",
        art = "art/classes/bard/bard_collecting_cap",
        frame = "frames/bard_frames/bard_treasure_cardframe",
        cardTypeLabel = "Magical Armor",
        xmlText = [[<vlayout spacing="1" forcewidth="true">
                        <hlayout spacing="1" forcewidth="true">
                            <icon text="{requiresHealth_20}" fontsize="90"/>    
                            <text text="If you have 
a song in play 
gain {gold_1} or {health_3}." fontsize="30"/>
                        </hlayout>
                    </vlayout>]]
    })

    return createMagicArmorDef({
        id = "bard_collecting_cap",
        name = "Collecting Cap",
        types = { bardType, magicArmorType, treasureType, headType },
        layout = cardLayout,
        layoutPath = "icons/bard/bard_collecting_cap",
        abilities = {
            createAbility({
                id = "bard_collecting_cap_activate",
                trigger = uiTrigger,
                cost = expendCost,
                check = getPlayerHealth(currentPid).gte(20).And(selectLoc(currentInPlayLoc).union(selectLoc(currentCastLoc)).where(isCardType(songType)).count().gte(1)),
                effect = pushChoiceEffect({
                    choices = {
                        {
                            effect = gainGoldEffect(1),
                            layout = createLayout({
                                name = "Gain 1 Gold",
                                art = "art/classes/bard/bard_collecting_cap",
                                xmlText = [[<icon text="{gold_1}" fontsize="60"/>]]
                            }),
                        },
                        {
                            condition = getPlayerHealth(currentPid).eq(getPlayerMaxHealth(currentPid)).invert(),
                            effect = healPlayerEffect(currentPid, 3),
                            layout = createLayout({
                                name = "Gain 3 Health",
                                art = "art/classes/bard/bard_collecting_cap",
                                xmlText = [[<icon text="{health_3}" fontsize="60"/>]]
                            }),
                        }
                    }
                })
            })
        }
    })
end
--===============================================
-- Bard dancing blade is a non guard with 1 defence.  It grants 2 damage and 1 gold and has auto trigger.
function bard_dancing_blade_carddef()
    local cardLayout = createLayout({
        name = "Dancing Blade",
        art = "art/classes/bard/bard_dancing_blade",
        frame = "frames/bard_frames/bard_champion_cardframe",
        cardTypeLabel = "Champion",
        xmlText = [[<hlayout forceheight="true" spacing="30">
                        <icon text="{expend}" fontsize="50"/>
                        <icon text="{combat_2}{gold_1}" fontsize="70"/>
                        <spacer /> <spacer />
                    </hlayout>]],
        isGuard = false,
        types = { championType, noStealType, bardType},
        health = 1,
    })

    return createChampionDef({
        id = "bard_dancing_blade",
        name = "Dancing Blade",
        acquireCost = 0,
        health = 1,
        isGuard = false,
        layout = cardLayout,
        factions = {},
        types = { championType, noStealType, bardType},
        layoutPath = "icons/bard/bard_dancing_blade",
        abilities = {
            createAbility({
                id = "bard_dancing_blade_ability",
                effect = gainCombatEffect(2).seq(gainGoldEffect(1)),
                cost = expendCost,
                trigger = autoTrigger,
                tags = { gainCombatTag, aiPlayAllTag }
            })
        }
    })
end

-- Bard necros dirge is a necros faction card that grants 2 combat and 
-- the next time you acquire a necros champion this turn you may sacrifice
-- a card in your hand or discard pile.
function bard_necros_dirge_carddef()
    local cardLayout = createLayout({
        name = "Necros Dirge",
        art = "art/classes/bard/bard_necros_dirge",
        frame = "frames/bard_frames/bard_action_cardframe",
        cardTypeLabel = "Action",
        xmlText = [[<vlayout forceheight="false" spacing="6">
                        <hlayout spacing="10">
                        <icon text="{combat_2}" fontsize="50"/>
                        </hlayout>    
                        <hlayout forcewidth="true" spacing="10">
                            <vlayout  forceheight="false">
                                <text text="The next time you acquire a {necro} champion this turn you may sacrifice a card in your hand or discard pile." fontsize="20"/>
                            </vlayout>
                        </hlayout>
                    </vlayout>]],
    })
    local sacrificeTrigger = "necros_dirge_sacrifice_trigger"
    return createActionDef({
        id = "bard_necros_dirge",
        name = "Necros Dirge",
        acquireCost = 0,
        layout = cardLayout,
        factions = {necrosFaction},
        types = { actionType, bardType, songType},
        layoutPath = "icons/bard/bard_necros_dirge",
        abilities = {
            createAbility({
                id = "bard_necros_dirge_ability",
                effect = gainCombatEffect(2),
                trigger = autoTrigger,
                activations = singleActivation,
                tags = { gainCombatTag, aiPlayAllTag }
            }),
            createAbility({
                id = "bard_necros_dirge_sacrifice_ability",
                effect = pushTargetedEffect({
                            desc="Necros Dirge: sacrifice a card from hand or discard.",
                            min=0,
                            max=1,
                            validTargets = selectLoc(currentHandLoc).union(selectLoc(currentDiscardLoc)),
                            targetEffect = sacrificeTarget(),      
                        }),
                trigger = abilityTrigger(sacrificeTrigger),
                activations = singleActivation,
            })
        },
        cardEffectAbilities = {
            createCardEffectAbility({
                trigger = acquiredCardTrigger,
                effect = ifEffect(
                    selectTargets().where(isCardChampion().And(isCardFaction(necrosFaction))).count().gte(1),
                    fireAbilityTriggerEffect(sacrificeTrigger)
                ),
                activations = multipleActivations,
            })
        }
    })
end


--Cleric
--=======================================================================================================
function cleric_redeemed_ruinos_carddef()
    local cardLayout = createLayout({
        name = "Redeemed Ruinos",
        art = "art/t_cleric_redeemed_ruinos",
        frame = "frames/Cleric_CardFrame",
        cardTypeLabel = "Champion",
        isGuard = false,
        health = 2,
        types = { championType, noStealType, humanType, clericType, noKillType},
        xmlText = [[<vlayout forceheight="false" spacing="6">
                        <hlayout spacing="10">
                        <text text="When stunned, {health_2}." fontsize="32"/>
                        </hlayout>    
                        <divider/>
                        <hlayout forcewidth="true" spacing="10">
                            <icon text="{expend}" fontsize="52"/>
                            <vlayout  forceheight="false">
                        <icon text="{gold_1}" fontsize="46"/>
                            </vlayout>
                            <icon text=" " fontsize="20"/>
                        </hlayout>
                    </vlayout>
                    ]]
    })
    return createChampionDef({
        id = "cleric_redeemed_ruinos",
        name = "Redeemed Ruinos",
        acquireCost = 0,
        health = 2,
        isGuard = false,
        layout = cardLayout,
        factions = {},
        types = { championType, noStealType, humanType, clericType, noKillType},
        tags = {noAttackButtonTag},
        abilities = {
            createAbility({
                id = "cleric_redeemed_ruinos",
                trigger = autoTrigger,
                activations = multipleActivations,
                cost = expendCost,
                effect = gainGoldEffect(1)
            }),
            createAbility({
                id = "cleric_redeemed_ruinos_stunned",
                trigger = onStunTrigger,
                effect = healPlayerEffect(ownerPid, 2).seq(simpleMessageEffect("2 <sprite name=\"health\"> gained from Redeemed Ruinos")),
                tags = { gainHealthTag }
            })
        }
    })
end

function ruinosDrawBuff()
    return createGlobalBuff({
        id="cleric_redeemed_ruinos_stunned",
        name="Ruinos Draw",
        abilities = {
            createAbility({
                id = "ruinos_draw",
                triggerPriority = 10,
                trigger = startOfTurnTrigger,
                cost = sacrificeSelfCost,
                effect = drawCardsEffect(1)
            }),
        },
        buffDetails = createBuffDetails({
            name = "Redeemed Ruinos",
            art = "art/t_cleric_redeemed_ruinos",
            text = "Draw a card."
        })
    })
end

--=========================================
function cleric_brightstar_shield_carddef()
    local cardLayout = createLayout({
        name = "Brightstar Shield",
        art = "art/t_cleric_brightstar_shield",
        frame = "frames/Cleric_CardFrame",
        cardTypeLabel = "Item",
        xmlText =[[<vlayout>
                    <hlayout flexibleheight="3">
                            <tmpro text="Draw 1.&lt;br&gt; Attach this to a friendly champion.&lt;br&gt;Prepare it and it has +2 {shield}." fontsize="20" flexiblewidth="1" />
                    </hlayout>
                </vlayout>]]
    })
    local fetchShields = moveTarget(loc(ownerPid, discardPloc)).apply(selectLoc(loc(oppPid, asidePloc)))
    -- local fetchShields = moveTarget(loc(ownerPid, discardPloc)).apply(selectLoc(loc(currentPid, asidePloc)))
                            --.seq(moveTarget(loc(ownerPid, discardPloc)).apply(selectLoc(loc(oppPid, asidePloc))))
    --
    local  oneChamp =  prepareTarget().apply(selectLoc(loc(currentPid,inPlayPloc)))
                        .seq(grantHealthTarget(2, { SlotExpireEnum.LeavesPlay }, fetchShields, "shield").apply(selectLoc(loc(currentPid,inPlayPloc))))
                        .seq(moveTarget(asidePloc).apply(selectLoc(loc(currentPid, castPloc)).where(isCardName("cleric_brightstar_shield"))))
    --
    local  multiChamp = pushTargetedEffect({
                            desc="Choose a champion to prepare and gain +2 defense from brightstar shield",
                            min=1,
                            max=1,
                            validTargets = selectLoc(loc(currentPid,inPlayPloc)).where(isCardChampion()),
                            targetEffect = prepareTarget().seq(grantHealthTarget(2, { SlotExpireEnum.LeavesPlay },fetchShields,"shield").apply(selectTargets())),
                        })
                        .seq(moveTarget(asidePloc).apply(selectLoc(loc(currentPid, castPloc)).where(isCardName("cleric_brightstar_shield"))))
    --
    local numChamps =  selectLoc(loc(currentPid,inPlayPloc)).where(isCardChampion()).count()
    --
    return createItemDef({
        id = "cleric_brightstar_shield",
        name = "Brightstar Shield",
        acquireCost = 0,
        cardTypeLabel = "Item",
        types = { itemType, noStealType, clericType, attachmentType},
        factions = {},
        layout = cardLayout,
        playLocation = castPloc,
            abilities = {
                    createAbility({
                        id = "brightMain",
                        trigger = autoTrigger,
                        playAllType = blockPlayType,
                        effect = drawCardsEffect(1).seq(ifElseEffect(numChamps.eq(0),
                                                            nullEffect(),
                                                            ifElseEffect(numChamps.eq(1),
                                                            oneChamp,
                                                            multiChamp)))
                    }),
                },
    })
end

--=========================================
function cleric_shining_breastplate_carddef()
    local card_name = "cleric_shining_breastplate"
	local cardLayout = createLayout({
        name = "Shining Breastplate",
        art = "art/t_cleric_shining_breastplate",
        frame = "frames/Cleric_CardFrame",
        cardTypeLabel = "Magical Armor",
        xmlText =[[<hlayout spacing="1" forcewidth="true">
                    <icon text="{requiresHealth_25}" fontsize="90"/>    
                    <text text="If you are at full health or have +{health} this turn,
                put a champion without a cost (3 {shield} max) from your discard into play." fontsize="18"/>
                    <text text=" " fontsize="80"/>
                </hlayout>]]
    })
	local noCostChamps = selectLoc(loc(currentPid, discardPloc)).where(isCardChampion().And(getCardCost().eq(0)).And(getCardHealth().lte(3)))
    local gainedHealthKey = "gainedHealthThisTurn"
    local gainedHealthSlot = createPlayerSlot({ key = gainedHealthKey, expiry = { endOfTurnExpiry } })
    return createMagicArmorDef({
        id = card_name,
        name = "Shining Breastplate",
        description = "<sprite name=\"Point\"><color=#3BF2FF><b>Available at level </b></color> 9",
        acquireCost = 0,
        types = { clericType, magicArmorType, treasureType, chestType },
        tags = { clericGalleryCardTag },
        level = 9,
        abilities = {
            createAbility({
                id = card_name .. "_auto_armor_on_start_turn_ability",
                effect = pushTargetedEffect(
                    {
                        desc = "Choose a champion without a cost to put in play",
                        validTargets = noCostChamps,
                        min = 0,
                        max = 1,
                        targetEffect = moveTarget(currentInPlayLoc),
                        tags = {toughestTag}                        
                    }
                ),
                trigger = uiTrigger,
                cost = expendCost,
                check = getPlayerHealth(currentPid).eq(getPlayerMaxHealth(currentPid))
                            .Or(hasPlayerSlot(currentPlayer(), gainedHealthKey))
                            .And(noCostChamps.where(getCardHealth().lte(3)).count().gte(1))
                            .And(getPlayerHealth(currentPid).gte(25)),
                tags = { gainCombatTag }
            }),
            createAbility({
                id = card_name .. "_track_health_gained",
                effect = showTextEffect("Congrats on the heal!").seq(
                addSlotToPlayerEffect(currentPlayer(), gainedHealthSlot)),
                trigger = gainedHealthTrigger,
                cost = noCost,
                tags = { toughestTag }
            }),
        },
        layoutPath = "icons/" .. card_name,
        layout = cardLayout
    })
end

--=========================================
function cleric_everburning_candle_carddef()
    local cardLayout = createLayout({
        name = "Everburning Candle",
        art = "art/t_cleric_everburning_candle",
        frame = "frames/Cleric_CardFrame",
        cardTypeLabel = "Item",
        xmlText =[[<vlayout>
                        <box flexibleheight="1">
                            <tmpro text="{gold_1}  {health_3}" fontsize="48"/>
                        </box>
                        <box flexibleheight="1">
                                    <tmpro text="or" fontsize="26"/>>
                        </box>
                        <box flexibleheight="1">
                            <tmpro text="Put a champion without a cost (3 {shield} max) from your discard into your hand." fontsize="14" />
                        </box>
                    </vlayout>]]
    })
    local cardLayoutHeal = createLayout({
        name = "Everburning Candle",
        art = "art/t_cleric_everburning_candle",
        frame = "frames/Cleric_CardFrame",
        cardTypeLabel = "Item",
        xmlText =[[<vlayout>
                    <hlayout flexibleheight="3">
                            <tmpro text="{gold_1}   {health_3}" fontsize="60" flexiblewidth="1" />
                    </hlayout>
                </vlayout>]]
    })
    local cardLayoutChamp = createLayout({
        name = "Everburning Candle",
        art = "art/t_cleric_everburning_candle",
        frame = "frames/Cleric_CardFrame",
        cardTypeLabel = "Item",
        xmlText =[[<vlayout>
                    <hlayout flexibleheight="3">
                            <tmpro text="Put a champion without a cost (3 {shield} max) from your discard into your hand." fontsize="25" flexiblewidth="1" />
                    </hlayout>
                </vlayout>]]
    })
   local noCostChamps = selectLoc(loc(currentPid, discardPloc)).where(isCardChampion().And(getCardCost().eq(0)).And(getCardHealth().lte(3)))
    --
    return createItemDef({
        id = "cleric_everburning_candle",
        name = "Everburning Candle",
        acquireCost = 0,
        cardTypeLabel = "Item",
        types = { itemType, noStealType, clericType},
        factions = {},
        layout = cardLayout,
        playLocation = castPloc,
            abilities = {
                    createAbility({
                        id = "brightMain",
                        trigger = autoTrigger,
                        playAllType = blockPlayType,
                        effect = pushChoiceEffect({
                                choices={
                                    {
                                        effect = healPlayerEffect(currentPid, 3).seq(gainGoldEffect(1)),
                                        layout = cardLayoutHeal,                     
                                    },
                                    {
                                        effect = pushTargetedEffect({
                                                        desc="Put a champion without a cost (3 {shield} max) from your discard into your hand.",
                                                        min=0,
                                                        max=1,
                                                        validTargets = noCostChamps,
                                                        targetEffect = moveTarget(loc(currentPid, handPloc)),
                                                        tags = {toughestTag}      
                                                    }),
                                        layout = cardLayoutChamp,
                                    }
                                }
                            })
                    }),
                },
    })
end

function cleric_imperial_sailor_carddef()
    local cardLayout = createLayout({
        name = "Imperial Sailor",
        art = "art/treasures/t_imperial_sailor",
        frame = "frames/Cleric_CardFrame",
        cardTypeLabel = "Champion",
        isGuard = false,
        health = 3,
        types = { championType, noStealType, humanType, clericType},
        xmlText = [[<vlayout>
                        <hlayout flexibleheight="1.8">
                            <box flexiblewidth="1">
                                <tmpro text="{expend}" fontsize="42"/>
                            </box>
                            <vlayout flexiblewidth="7">
                                <box flexibleheight="1">
                                    <tmpro text="Reserve 1" fontsize="18" />
                                </box>
                                <box flexibleheight="2">
                                    <tmpro text="{gold_1} {combat_2}" fontsize="42" />
                                </box>
                            </vlayout>
                        </hlayout>
                        <divider/>
                        <hlayout flexibleheight="1">
                            <box flexiblewidth="1">
                                <tmpro text="{scrap}" fontsize="42"/>
                            </box>
                            <box flexiblewidth="7">
                                <tmpro text="Sacrifice any number of cards in the market. Draw 1." fontsize="18" />
                            </box>>
                        </hlayout>
                    </vlayout>
                    ]]
    })
    return createChampionDef({
        id = "cleric_imperial_sailor",
        name = "Imperial Sailor",
        acquireCost = 0,
        health = 3,
        isGuard = false,
        layout = cardLayout,
        factions = {},
        types = { championType, noStealType, humanType, clericType},
        abilities = {
            createAbility({
                id = "cleric_imperial_sailor",
                trigger = autoTrigger,
                activations = multipleActivations,
                cost = expendCost,
                effect = gainGoldEffect(1).seq(gainCombatEffect(2))
            }),
             createAbility({
                id = "cleric_imperial_sailor_srap",
                trigger = uiTrigger,
                activations = singleActivations,
                cost = sacrificeSelfCost,
                effect = targetedEffect({
                    desc = "Sacrifice any number of cards in the market. Draw 1.",
                    min = 0,
                    max = 5,
                    validTargets = selectLoc(centerRowLoc),
                    targetEffect = sacrificeTarget().seq(drawCardsEffect(1)),
                })
            }),
        }
    })
end

--Thief
--=======================================================================================================
-- Blinding powders grants 3 gold, lets you return target champion to the bottom of its owners deck.
-- It has a self sacrifice ability to cause the opponent to discard a card.  It is a reserve 2 card.
function thief_blinding_powder_carddef()
    local cardLayout = createLayout({
        name = "Blinding Powder",
        art = "art/treasures/thief_blinding_powder",
        frame = "frames/Thief_CardFrame",
        xmlText = [[
                    <vlayout forceheight="false" spacing="5">
                        <vlayout forceheight="false" spacing = "0">
                            <text text="Reserve 2" fontsize="16" fontstyle="italic"/>
                            <icon text="{gold_3}" fontsize="40"/>
                            <text text="You may return target champion to the bottom of its owner's deck" fontsize="16"/> 
                        </vlayout>
                        <divider/>
                        <hlayout forcewidth="true" spacing="10">
                            <icon text="{scrap}" fontsize="30"/>
                            <text text="Target opponent discards a card." fontsize="16"/>
                            <icon text=" " fontsize="20"/>
                        </hlayout>
                    </vlayout>
                    ]]
    })

    local return_to_deck_trigger = "return_to_deck_trigger"
    local return_to_deck_ability = createAbility({
        id = "return_to_deck_ability",
        trigger = abilityTrigger(return_to_deck_trigger),
        effect = moveToBottomDeckTarget(true, 0).apply(selectSource())
    })
    local return_to_deck_slot = createAbilitySlot({
        ability = return_to_deck_ability,
        expiry = { neverExpiry }
    })

    return createItemDef({
        id = "thief_blinding_powder",
        name = "Blinding Powder",
        acquireCost = 0,
        cardTypeLabel = "Item",
        types = { itemType, noStealType, thiefType, reserveType},
        factions = {},
        layout = cardLayout,
        playLocation = castPloc,
        abilities = {
            createAbility({
                id = "thief_blinding_powder_onplay",
                trigger = autoTrigger,
                activations = singleActivation,
                effect = gainGoldEffect(3).seq(pushTargetedEffect({
                    desc = "Return target champion to the bottom of its owner's deck.",
                    min = 0,
                    max = 1,
                    validTargets = selectLoc(loc(currentPid, inPlayPloc)).union(selectLoc(loc(oppPid, inPlayPloc))).where(isCardChampion()),
                    targetEffect = addSlotToTarget(return_to_deck_slot).seq(fireAbilityTriggerForTarget(return_to_deck_trigger)),
                }))
            }),
            createAbility({
                id = "thief_blinding_powder_scrap",
                trigger = uiTrigger,
                activations = singleActivation,
                cost = sacrificeSelfCost,
                effect = oppDiscardEffect(1)
            }),
        }
    })
end

function thief_silent_boots_carddef()
    --
    local cardLayout = createLayout({
						name = "Silent Boots",
						art = "art/t_thief_silent_boots",
						frame = "frames/Thief_armor_frame",
						xmlText = [[<vlayout>
                                    <hlayout flexibleheight="1">
                                        <box flexiblewidth="1.5">
                                            <tmpro text="{requiresHealth_10}" fontsize="72"/>
                                        </box>
                                        <box flexiblewidth="7">
                                            <tmpro text="Reveal the top two cards from the market deck and sacrifice one. You may acquire the other for &lt;br&gt;1 {gold} less or put it back." fontsize="20" />
                                        </box>
                                    </hlayout>
                                </vlayout>]]
    })
    --
    local cardLayoutBuy = createLayout({
                                    name = "Silent Boots",
                                    art = "art/t_thief_silent_boots",
                                    frame = "frames/Thief_armor_frame",
                                    xmlText = [[<vlayout>
                                                    <hlayout flexibleheight="1">
                                                        <box flexiblewidth="7">
                                                            <tmpro text="Acquire for 1 {gold} less." fontsize="26" />
                                                        </box>
                                                    </hlayout>
                                                </vlayout>]]
                            })
    --
    local cardLayoutTopDeck = createLayout({
                                    name = "Silent Boots",
                                    art = "art/t_thief_silent_boots",
                                    frame = "frames/Thief_armor_frame",
                                    xmlText = [[<vlayout>
                                                    <hlayout flexibleheight="1">
                                                        <box flexiblewidth="7">
                                                            <tmpro text="Put it back on the top of the market deck." fontsize="26" />
                                                        </box>
                                                    </hlayout>
                                                </vlayout>]]
                                })
    --                            
    local effReveal =  noUndoEffect().seq(moveTarget(revealPloc).apply(selectLoc(tradeDeckLoc).take(2).reverse())
                            .seq(pushTargetedEffect({
                                    desc="Select one card to Sacrifice. The other card may be acquired for 1 less or put back on top of the market deck.",
                                    min = 1,
                                    max = 1,
                                    validTargets = selectLoc(revealLoc),
                                    targetEffect = sacrificeTarget(),
                                })))
        --
    local checkSelector = selectLoc(revealLoc).Where(isCardAcquirable().And(getCardCost().lte(getPlayerGold(currentPid).add(toIntExpression(1)))))
    --
    local effTopOrBuy = noUndoEffect().seq(pushChoiceEffect({
                                choices={
                                    {
                                        effect = acquireTarget(1,discardPloc).apply(selectLoc(revealLoc)),
                                        layout = cardLayoutBuy,
                                        condition = checkSelector.count().gte(1),                      
                                    },
                                    {
                                        effect = moveTarget(tradeDeckLoc).apply(selectLoc(revealLoc)),            
                                        layout = cardLayoutTopDeck,
                                    }
                                }
                            }))
    --
    return createMagicArmorDef({
        id = "thief_silent_boots",
        name = "Silent Boots",
        types = { magicArmorType, thiefType, feetType, treasureType },
        layout = cardLayout,
        abilities = {
            createAbility({
                id = "triggerBoots",
				trigger = uiTrigger,
                layout = cardLayout,
				promptType = showPrompt,
                check =  minHealthCurrent(10),
                effect = noUndoEffect().seq(effTopOrBuy).seq(effReveal),
        }),
    },
		layoutPath = "icons/thief_silent_boots"
    })
end

--=========================================
function thief_enchanted_garrote_carddef()
    local cardLayout = createLayout({
        name = "Enchanted Garrote",
        art = "art/t_thief_enchanted_garrote",
        frame = "frames/Thief_CardFrame",
        cardTypeLabel = "Item",
        xmlText =[[<vlayout>
                    <hlayout flexibleheight="2.5">
                            <tmpro text="&lt;space=0.2em/&gt;{combat_1} {gold_1}" fontsize="50" flexiblewidth="8" />
                    </hlayout>
                    <hlayout flexibleheight="4">
                            <tmpro text="If you stun a champion this turn, gain {gold_1}" fontsize="20" flexiblewidth="1" />
                    </hlayout>
                </vlayout>]]
    })
    --Discard for chapions, Sacrificed for tokens
    local stunnedChamps = selectLoc(loc(oppPid, discardPloc)).union(selectLoc(loc(oppPid, sacrificePloc))).where(isCardStunned()).count()
    --
    return createItemDef({
        id = "thief_enchanted_garrote",
        name = "Enchanted Garrote",
        acquireCost = 0,
        cardTypeLabel = "Item",
        types = { itemType, noStealType, thiefType, garoteType, weaponType},
        factions = {},
        layout = cardLayout,
        playLocation = castPloc,
            abilities = {
                createAbility({
                    id = "garroteMain",
                    trigger = autoTrigger,
                    check = stunnedChamps.eq(0),
                    effect = gainCombatEffect(1).seq(gainGoldEffect(1)).seq(addSlotToPlayerEffect(currentPid, createPlayerSlot({ key = "champStunnedSlot", expiry = { endOfTurnExpiry } })))
                }),
                createAbility({
                    id = "garroteSlot",
                    trigger = autoTrigger,
                    check = hasPlayerSlot(currentPid, "champStunnedSlot").invert().And(stunnedChamps.gte(1)),
                    effect = gainCombatEffect(1).seq(gainGoldEffect(2))
                }),
                createAbility({
                    id = "garroteStun",
                    trigger = onStunGlobalTrigger,
                    activations = singleActivation,
                    effect = ifElseEffect(hasPlayerSlot(currentPid, "champStunnedSlot").And(stunnedChamps.gte(1)),
                                            gainGoldEffect(1),
                                            nullEffect()) 
                })
                },
    })
end

function draw_a_card_ability()
    return createAbility({
        id = "draw_a_card",
        trigger = autoTrigger,
        effect = drawCardsEffect(1)
    })
end
--Monk
--=========================================
function monk_horn_of_ascendance_carddef()
    -- This card draws 1 and grants 2 gold after your next acquisition.
    local cardLayout = createLayout({
        name = "Horn of Ascendance",
        art = "art/classes/monk/monk_horn_of_ascendance",
        frame = "frames/monk_frames/monk_item_cardframe",
        cardTypeLabel = "Item",
        xmlText =[[<vlayout>
                    <text text="Reserve 1" fontsize="22" fontstyle="italic"/>
                    <text text="Draw 1.
                    The next time you acquire a card this turn, gain 2 {gold}." fontsize="27"/>                           
                </vlayout>]]
    })
    return createItemDef({
        id = "monk_horn_of_ascendance",
        name = "Horn of Ascendance",
        acquireCost = 0,
        types = { itemType, noStealType, monkType, hornType,reserveType },
        factions = {},
        playLocation = castPloc,
        layout = cardLayout,
        abilities = {
            draw_a_card_ability(),
            createAbility({
                id = "monk_horn_of_ascendance_ability",
                trigger = onAcquireGlobalTrigger,
                activations = singleActivation,
                cost = noCost,
                effect = gainGoldEffect(2)
            })
        }
    })
end

--=======================================
function monk_wraps_of_strength_carddef()
    local card_name = "monk_wraps_of_strength"
	local cardLayout = createLayout({
        name = "Wraps of Strength",
        art = "art/classes/monk/monk_wraps_of_strength",
        frame = "frames/monk_frames/monk_treasure_cardframe",
        cardTypeLabel = "Magic Armor",
        xmlText =[[<hlayout spacing="10" forcewidth="true">
                    <icon text="{requiresHealth_25}" fontsize="90"/>    <vlayout spacing="1">
                    <text text="
                    If you have 4 
                    Tao Lu 
                    actions in play," fontsize="24"/>
                                        <text text="{combat_2} {health_2}" fontsize="40"/>
                                        </vlayout>
                                    </hlayout>]]
    })
    return createMagicArmorDef({
        id = card_name,
        name = "Wraps of Strength",
        acquireCost = 0,
        types = { monkType, magicArmorType, treasureType },
        level = 9,
        abilities = {
            createAbility({
                id = "monk_wraps_of_strength_ability",
                trigger = autoTrigger,
                check = getPlayerHealth(currentPid).gte(25).And(getCustomValue(currentPid).gte(4)),
                effect = gainCombatEffect(2).seq(gainHealthEffect(2))
            })
        },
        layoutPath = "icons/monk/monk_wraps_of_strength",
        layout = cardLayout
    })
end

function monk_cobra_fang_carddef()
    -- This card draws 1 and grants 2 gold after your next acquisition.
    local cardLayout = createLayout({
        name = "Cobra Fang",
        art = "art/classes/monk/monk_cobra_fang",
        frame = "frames/monk_frames/monk_action_cardframe",
        cardTypeLabel = "Action",
        xmlText =[[<vlayout spacing="20"> 
                <text text="Gain 1 {combat} for each Tao Lu action in play." fontsize="26"/>
                <text text="You count as having an extra Tao Lu action this turn." fontsize="26"/>
                </vlayout>]]
    })
    local counter_name = "cobra_fang_last_custom_value"
    local trigger_name = "cobra_fang_add_one_damage"
    local trigger2_name = "cobra_fang_add_two_damage"
    return createItemDef({
        id = "monk_cobra_fang",
        name = "Horn of Ascendance",
        acquireCost = 0,
        types = { actionType, noStealType, monkType, taoLuType },
        factions = {},
        playLocation = castPloc,
        layout = cardLayout,
        abilities = {
            createAbility({
                id = "monk_cobra_fang_on_play_ability",
                trigger = autoTrigger,
                activations = singleActivation,
                cost = noCost,
                effect = gainCombatEffect(getCustomValue(currentPid))
                    .seq(resetCounterEffect(counter_name))
                    .seq(incrementCounterEffect(counter_name, getCustomValue(currentPid)))
                    .seq(gainCustomValueEffect(2))
            }),
            -- We break up the detect and the gain combat ability so that
            -- this could work properly if you had multiple copies of this
            -- card in play at the same time.
            createAbility({
                id = "monk_cobra_incremental_damage_ability",
                trigger = abilityTrigger(trigger_name),
                activations = multipleActivations,
                cost = noCost,
                effect = gainCombatEffect(1)
            }),
            createAbility({
                id = "monk_cobra_incremental_damage_ability2",
                trigger = abilityTrigger(trigger2_name),
                activations = multipleActivations,
                cost = noCost,
                effect = gainCombatEffect(2)
            }),
            createAbility({
                id = "monk_cobra_fang_ability",
                trigger = autoTrigger,
                activations = multipleActivations,
                cost = noCost,
                check = getCustomValue(currentPid).gte(getCounter(counter_name).add(1)),
                -- For QOL if we gain 2 Tao Lu from 1 action we show a +2 animation instead of 2 +1
                -- animations.
                effect = ifElseEffect(getCustomValue(currentPid).gte(getCounter(counter_name).add(2)),
                    incrementCounterEffect(counter_name, 2).seq(fireAbilityTriggerEffect(trigger2_name)),
                    incrementCounterEffect(counter_name, 1).seq(fireAbilityTriggerEffect(trigger_name)))
            })
        }
    })
end

--====================================
function replace_spring_blossom_buff()
    local spring_blossom_selector = function(player_id) 
        return selectLoc(loc(player_id, handPloc)).union(selectLoc(loc(player_id, deckPloc)))
            .where(isCardName("monk_spring_blossom")) 
    end
    local ef = ifEffect(spring_blossom_selector(currentPid).count().gte(6),
            randomTarget(const(1), transformTarget("monk_resplendent_blossom"))
                .apply(spring_blossom_selector(currentPid)))
        .seq(ifEffect(spring_blossom_selector(oppPid).count().gte(6),
            randomTarget(const(1), transformTarget("monk_resplendent_blossom"))
                .apply(spring_blossom_selector(oppPid))))
        .seq(sacrificeSelf())

    return createGlobalBuff({
        id = "fix_monk_gold_upgrade",
        name = "Monk Gold Upgrade Fixer",
        abilities = {
            createAbility({
                id = "fix_monk_gold_upgrade_ability",
                trigger = startOfGameTrigger,
                effect = ef
            })
        }
    })
end

function replace_bard_dagger_buff()
    local dagger_selector = function(player_id) 
        return selectLoc(loc(player_id, handPloc)).union(selectLoc(loc(player_id, deckPloc)))
            .where(isCardName("dagger")) 
    end
    local player_has_necros_dirge = function(player_id) 
        return selectLoc(loc(player_id, handPloc)).union(selectLoc(loc(player_id, deckPloc)))
            .where(isCardName("bard_necros_dirge")).count().gte(1) 
    end
    local ef = ifEffect(player_has_necros_dirge(currentPid),
            randomTarget(const(1), transformTarget("gold"))
                .apply(dagger_selector(currentPid)))
        .seq(ifEffect(player_has_necros_dirge(oppPid),
            randomTarget(const(1), transformTarget("gold"))
                .apply(dagger_selector(oppPid))))
        .seq(sacrificeSelf())

    return createGlobalBuff({
        id = "replace_bard_dagger",
        name = "Bard Dagger Replacer",
        abilities = {
            createAbility({
                id = "replace_bard_dagger_ability",
                trigger = startOfGameTrigger,
                effect = ef
            })
        }
    })
end

function replace_necromancer_dagger_buff()
    local dagger_selector = function(player_id) 
        return selectLoc(loc(player_id, handPloc)).union(selectLoc(loc(player_id, deckPloc)))
            .where(isCardName("dagger")) 
    end
    local player_has_bone_dance_or_bloodrose = function(player_id) 
        return selectLoc(loc(player_id, handPloc)).union(selectLoc(loc(player_id, deckPloc)))
            .where(isCardName("necromancer_bone_dance").Or(isCardName("necromancer_bloodrose"))).count().gte(1) 
    end
    local ef = ifEffect(player_has_bone_dance_or_bloodrose(currentPid),
            randomTarget(const(1), transformTarget("gold"))
                .apply(dagger_selector(currentPid)))
        .seq(ifEffect(player_has_bone_dance_or_bloodrose(oppPid),
            randomTarget(const(1), transformTarget("gold"))
                .apply(dagger_selector(oppPid))))
        .seq(sacrificeSelf())

    return createGlobalBuff({
        id = "replace_necromancer_dagger",
        name = "Necromancer Dagger Replacer",
        abilities = {
            createAbility({
                id = "replace_necromancer_dagger_ability",
                trigger = startOfGameTrigger,
                effect = ef
            })
        }
    })
end

-- This is a global buff that converts toughness into a guard token
-- at the end of the turn.  The token is sacrificed at the beginning
-- of your next turn.

-- We use this to track the players current toughness because we can't
-- access the players current toughness directly.
local old_gain_toughness = gainToughnessEffect
function gainToughnessEffect(amount)
    return incrementCounterEffect("toughness_counter", amount).seq(old_gain_toughness(amount))
end

function toughness_token_carddef()
    local cardLayout = createLayout({
        name = "Toughness Token",
        art = "art/epicart/shield_of_tarken",
        frame = "frames/Warrior_CardFrame",
        cardTypeLabel = "Champion",
        isGuard = true,
        health = 1,
        types = { },
        text = "Toughness token."
    })
    return createChampionDef({
        id = "toughness_token",
        name = "Toughness Token",
        acquireCost = 0,
        health = 1,
        isGuard = true,
        layout = cardLayout,
        types = { championType, humanType, fighterType },
        factions = {},
        abilities = {
            createAbility({
                id = "toughness_token_self_sacrifice",
                trigger = startOfTurnTrigger,
                activations = singleActivation,
                effect = sacrificeSelf()
            }),
            sacrificeSelfOnLeavePlayAbility("toughness_token_leave_play_self_sacrifice")
        }
    })
end

function end_of_turn_toughness_converter_buff()
    local ef = ifEffect(getCounter("toughness_counter").gte(1), 
        old_gain_toughness(getCounter("toughness_counter").negate())
            .seq(createCardEffect(toughness_token_carddef(), currentInPlayLoc))
            .seq(grantHealthTarget(getCounter("toughness_counter").add(-1)).apply(
                    selectLoc(currentInPlayLoc).where(isCardName("toughness_token"))
                ))
            .seq(resetCounterEffect("toughness_counter"))
    )
    return createGlobalBuff({
        id = "end_of_turn_toughness_converter_buff",
        name = "Toughness Converter",
        abilities = {
            createAbility({
                id = "end_of_turn_toughness_converter_buff_ability",
                trigger = endOfTurnTrigger,
                effect = ef
            })
        }
    })
end