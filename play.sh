#!/bin/bash

# Define player attributes
player_name=""
player_level=1
player_experience=0
player_health=100
player_max_health=100
player_attack=10
player_defense=5
player_gold=0
player_inventory=()

# Define constants
MAX_HEALTH_INCREASE=10
ATTACK_INCREASE=5
DEFENSE_INCREASE=3
EXPERIENCE_PER_LEVEL=100
ITEM_DROP_PROBABILITY=30

# Function to display the introduction and prompt player to enter their name
introduction() {
    echo "Welcome to the Chronicles of the Celestial Forest!"
    echo "A realm of boundless magic and adventure awaits."
    if [ -z "$player_name" ]; then
        read -p "What is your name, adventurer? " player_name
        echo "Welcome, $player_name! Your journey begins now."
    else
        echo "Welcome back, $player_name! Your adventure continues."
    fi
}

# Function to display player's stats
display_stats() {
    echo "============================"
    echo "Name: $player_name | Level: $player_level | Experience: $player_experience"
    echo "Health: $player_health/$player_max_health | Attack: $player_attack | Defense: $player_defense"
    echo "Gold: $player_gold"
    echo "Inventory: ${player_inventory[@]}"
    echo "============================"
}

# Function to handle player movement
move() {
    case $1 in
        north)  echo "You ascend towards the celestial canopy, where stars dance in an eternal ballet." ;;
        south)  echo "You descend into the depths of the forest, where the roots of existence intertwine." ;;
        east)   echo "You journey towards the horizon, where the dawn of creation illuminates ancient truths." ;;
        west)   echo "You venture into the twilight realm, where shadows whisper secrets of forgotten epochs." ;;
        *)      echo "Invalid direction." ;;
    esac
}

# Function to simulate a random encounter with a creature
encounter() {
    creature_name="Mystical Beast"
    creature_health=$(( (RANDOM % 50) + 50 )) # Health between 50 and 100
    creature_attack=$(( (RANDOM % 5) + 5 ))   # Attack between 5 and 10
    creature_defense=$(( (RANDOM % 3) + 3 ))  # Defense between 3 and 5
    echo "You encounter a $creature_name with $creature_health health, $creature_attack attack, and $creature_defense defense!"
    while [ $creature_health -gt 0 ] && [ $player_health -gt 0 ]; do
        player_damage=$(( (RANDOM % player_attack) + 1 ))
        creature_damage=$(( (RANDOM % creature_attack) + 1 ))
        player_damage=$(( player_damage - creature_defense )) # Adjust player damage by creature defense
        player_damage=$(( player_damage > 0 ? player_damage : 1 )) # Ensure player damage is at least 1
        creature_health=$(( creature_health - player_damage ))
        echo "You attack the $creature_name for $player_damage damage. It has $creature_health health left."
        if [ $creature_health -le 0 ]; then
            echo "You have defeated the $creature_name! You gain 50 experience and 10 gold."
            player_experience=$(( player_experience + 50 ))
            player_gold=$(( player_gold + 10 ))
            level_up
            get_item
            visit_marketplace
        else
            creature_damage=$(( creature_damage - player_defense )) # Adjust creature damage by player defense
            creature_damage=$(( creature_damage > 0 ? creature_damage : 1 )) # Ensure creature damage is at least 1
            player_health=$(( player_health - creature_damage ))
            echo "$creature_name attacks you for $creature_damage damage. You have $player_health health left."
        fi
        sleep 1
    done
    if [ $player_health -le 0 ]; then
        echo "You have been defeated by the $creature_name. Game Over!"
        exit
    fi
}

# Function to handle player leveling up
level_up() {
    if [ $player_experience -ge $(( player_level * EXPERIENCE_PER_LEVEL )) ]; then
        player_level=$(( player_level + 1 ))
        player_experience=$(( player_experience - (player_level * EXPERIENCE_PER_LEVEL) ))
        player_max_health=$(( player_max_health + MAX_HEALTH_INCREASE ))
        player_health=$(( player_health + MAX_HEALTH_INCREASE ))
        player_attack=$(( player_attack + ATTACK_INCREASE ))
        player_defense=$(( player_defense + DEFENSE_INCREASE ))
        echo "Congratulations! You have reached Level $player_level."
        echo "Your health, attack, and defense have increased."
    fi
}

# Function to simulate acquiring an item
get_item() {
    if [ $(( RANDOM % 100 )) -lt $ITEM_DROP_PROBABILITY ]; then
        item="Mystical Amulet"
        echo "You have found a $item! It has been added to your inventory."
        player_inventory+=("$item")
        check_amulet_effect
    fi
}

# Function to check the effect of the mystical amulet
check_amulet_effect() {
    amulet_effect=$(( RANDOM % 2 )) # Randomly choose between 0 (negative effect) and 1 (positive effect)
    if [ $amulet_effect -eq 0 ]; then
        echo "The mystical amulet emits a dark energy, draining your health."
        player_health=$(( player_health - 20 ))
        if [ $player_health -le 0 ]; then
            echo "The dark energy consumes you. Game Over!"
            exit
        fi
    else
        echo "The mystical amulet shines with radiant energy, restoring your health."
        player_health=$(( player_health + 20 ))
        if [ $player_health -gt $player_max_health ]; then
            player_health=$player_max_health
        fi
    fi
}

# Function to visit the marketplace
visit_marketplace() {
    marketplace_chance=$(( RANDOM % 10 )) # Randomly determine if the player encounters a marketplace (10% chance)
    if [ $marketplace_chance -eq 0 ]; then
        clear
        echo "As you continue your journey, you stumble upon a mysterious marketplace."
        echo "Welcome to the Celestial Marketplace, $player_name!"
        echo "You can spend your gold here to acquire valuable items and maps."
        echo "1. Purchase a Map to find your beloved girl - 50 gold"
        echo "2. Purchase a Healing Potion - 20 gold"
        echo "3. Purchase a Dark Scroll - 30 gold"
        echo "4. Leave the marketplace"
        read -p "Enter your choice: " choice
        case $choice in
            1) purchase_map ;;
            2) purchase_potion ;;
            3) purchase_dark_scroll ;;
            4) echo "Farewell, $player_name! Safe travels." ;;
            *) echo "Invalid choice." ;;
        esac
    fi
}

# Function to purchase a map to find the player's beloved girl
purchase_map() {
    if [ $player_gold -ge 50 ]; then
        echo "You purchase a Map to find your beloved girl for 50 gold."
        player_gold=$(( player_gold - 50 ))
        echo "You now have a clear direction to find your beloved girl!"
    else
        echo "You don't have enough gold to purchase a Map."
    fi
}
# Function to purchase a healing potion
purchase_potion() {
    if [ $player_gold -ge 20 ]; then
        echo "You purchase a Healing Potion for 20 gold."
        player_gold=$(( player_gold - 20 ))
        player_health=$(( player_health + 20 ))
        if [ $player_health -gt $player_max_health ]; then
            player_health=$player_max_health
        fi
        echo "Your health has been restored."
    else
        echo "You don't have enough gold to purchase a Healing Potion."
    fi
}

# Function to purchase a dark scroll
purchase_dark_scroll() {
    if [ $player_gold -ge 30 ]; then
        echo "You purchase a Dark Scroll for 30 gold."
        player_gold=$(( player_gold - 30 ))
        echo "The scroll whispers grim truths about life, leaving you pondering in darkness."
    else
        echo "You don't have enough gold to purchase a Dark Scroll."
    fi
}

# Main game loop
introduction
while true; do
    display_stats
    read -p "Enter your move (north/south/east/west): " direction
    move "$direction"
    encounter
    if [ $player_level -ge 10 ]; then
        ending
        exit
    fi
done

