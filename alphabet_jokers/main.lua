SMODS.current_mod.optional_features = { retrigger_joker = true }
SMODS.optional_features.cardareas.unscored = true

SMODS.Atlas {
    key = "alphabet_atlas",
    path = "placeholders.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = "letter_a",
    loc_txt = {
        name = "A",
        text = {
            "{C:mult}+#1#{} Mult"
        }
    },
    config = { extra = { mult = 10 } },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
    rarity = 1,
    atlas = "alphabet_atlas",
    pos = { x = 0, y = 0 },
    cost = 3,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end
    end
}

SMODS.Joker {
    key = "letter_b",
    loc_txt = {
        name = "B",
        text = {
            "{C:green}#1# in #2#{} chance to retrigger an uncommon joker,",
            "{C:attention}except this joker{}"
        }
    },
    config = { extra = { odds = 2 } },
    rarity = 2,
    atlas = "alphabet_atlas",
    pos = { x = 1, y = 0 },
    loc_vars = function (self, info_queue, card)
        return {
            vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds }
        }
    end,
    calculate = function (self, card, context)
        if context.retrigger_joker_check and context.other_card.config.center.rarity == 2 and context.other_card ~= card then
            if pseudorandom('letter_b') < G.GAME.probabilities.normal / card.ability.extra.odds then
                return { card = card, repetitions = 1, message = "Yep!", message_card = card }
            else
                return { card = card, message = "Nope!", message_card = card }
            end
        end 
    end
}

SMODS.Joker {
    key = "letter_c",
    loc_txt = {
        name = "C",
        text = {
            "{X:mult,C:white}X#1#{} Mult"
        }
    },
    config = { extra = { Xmult = 2 } },
    rarity = 2,
    atlas = "alphabet_atlas",
    pos = { x = 1, y = 0 },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return { 
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.Xmult }}
            }
        end
    end
}

SMODS.Joker {
    key = "letter_d",
    loc_txt = {
        name = "D",
        text = {
            "Retrigger each played {C:attention}#1#{}"
        }
    },
    config = { extra = { cardRank = 4 } },
    rarity = 2,
    atlas = "alphabet_atlas",
    pos = { x = 1, y = 0 },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.cardRank } }
    end,
    calculate = function (self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card:get_id() == card.ability.extra.cardRank then
                return {
                    repetitions = 1,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker {
    key = "letter_e",
    loc_txt = {
        name = "E",
        text = {
            "{C:chips}+#1#{} Chips"
        }
    },
    config = { extra = { chips = 30 } },
    rarity = 1,
    atlas = "alphabet_atlas",
    pos = { x = 0, y = 0 },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } }
            }
        end
    end
}

SMODS.Joker {
    key = "letter_f",
    loc_txt = {
        name = "F",
        text = {
            "Destroyed cards give {C:money}$#1#{}"
        }
    },
    config = { extra = { money = 3 } },
    rarity = 2,
    atlas = "alphabet_atlas",
    pos = { x = 1, y = 0 },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function (self, card, context)
        if context.remove_playing_cards then
            return {
                dollars = card.ability.extra.money * #context.removed
            } 
        end
    end
}

SMODS.Joker {
    key = "letter_g",
    loc_txt = {
        name = "G",
        text = {
            "{C:money}$#1#{} after you beat a {C:attention}round{}"
        }
    },
    config = { extra = { money = 5 } },
    rarity = 1,
    atlas = "alphabet_atlas",
    pos = { x = 0, y = 0 },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function (self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                dollars = card.ability.extra.money
            }
        end
    end
}

SMODS.Joker {
    key = "letter_h",
    loc_txt = {
        name = "H",
        text = {
            "{X:mult,C:white}X#1#{} Mult,",
            "loses {X:mult,C:white}X#2#{} Mult every {C:attention}Ante{}"
        }
    },
    config = { extra = { Xmult = 3, lostXmult = 0.25 } },
    rarity = 2,
    atlas = "alphabet_atlas",
    pos = { x = 1, y = 0 },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.lostXmult } }
    end,
    calculate = function (self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            if G.GAME.blind.boss then
                if card.ability.extra.Xmult > 1.25 then
                    card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.lostXmult
                    return {
                        message = "Downgrade!"
                    }
                else
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            card:juice_up(0.8, 0.8)
                            card:start_dissolve({ HEX("63f06b") }, nil, 1.6)
                            return true
                        end
                    }))
                end
            end
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.Xmult }}
            }
        end
    end
}

SMODS.Joker {
    key = "letter_i",
    loc_txt = {
        name = "I",
        text = {
            "Gains {C:mult}+#1#{} mult every #2# cards {C:attention}scored{}",
            "{C:inactive}(Currently {}{C:mult}+#3#{} {C:inactive}Mult){}"
        }
    },
    config = { extra = { gainMult = 1, scoredCards = 3, mult = 0, currentScoredCards = 0 } },
    rarity = 2,
    atlas = "alphabet_atlas",
    pos = { x = 1, y = 0 },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.gainMult, card.ability.extra.scoredCards, card.ability.extra.mult, card.ability.extra.currentScoredCards } }
    end,
    calculate = function (self, card, context)
        if context.after then
            for i = 1, #context.scoring_hand do
                card.ability.extra.currentScoredCards = card.ability.extra.currentScoredCards + 1
            end

            card.ability.extra.mult = math.floor(card.ability.extra.currentScoredCards / card.ability.extra.scoredCards) * card.ability.extra.gainMult
        end
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = "variable", key = "a_mult", vars = { card.ability.extra.mult }}
            }
        end
    end
}

SMODS.Joker {
    key = "letter_j",
    loc_txt = {
        name = "J",
        text = {
            "This joker gains {C:mult}+#1#{} Mult per unscored {C:attention}Jack{}",
            "{C:inactive}(Currently {}{C:mult}+#2#{} {C:inactive}Mult){}"
        }
    },
    config = { extra = { gainMult = 6, mult = 0 } },
    rarity = 2,
    atlas = "alphabet_atlas",
    pos = { x = 1, y = 0 },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.gainMult, card.ability.extra.mult } }
    end,
    calculate = function (self, card, context)
        if context.cardarea == 'unscored' and context.individual then
            if context.other_card:get_id() == 11 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gainMult
            end
        end
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = "variable", key = "a_mult", vars = { card.ability.extra.mult }}
            }
        end
    end
}

SMODS.Joker {
    key = "five_dollar_joker",
    loc_txt = {
        name = "Five Dollar Joker",
        text = {
            "{C:money}$#1#{} at the end of each {C:attention}round{}"
        }
    },
    config = { extra = { money = 5 } },
    rarity = 1, -- Adjust rarity if needed
    atlas = "default_jokers", -- Use default or provide custom atlas
    pos = { x = 0, y = 0 }, -- Adjust position for the sprite
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        -- Ensure the Joker gives the money at the end of the round
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                dollars = card.ability.extra.money,
                message = localize { type = "variable", key = "five_dollar_bonus", vars = { card.ability.extra.money } }
            }
        end
    end
}