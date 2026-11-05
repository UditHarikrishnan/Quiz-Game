#!/bin/sh

QUESTIONS_FILE="questions.txt"
SCORES_FILE="scores.txt"

show_menu() {
    echo "--------------------"
    echo "       Quiz Game"
    echo "--------------------"
    echo "1. Start Quiz"
    echo "2. View Scores"
    echo "3. Add Question"
    echo "4. Exit"
}

start_quiz() {
    score=0
    total=0
    found=0

    if [ ! -s "$QUESTIONS_FILE" ]; then
        echo "No questions yet. Add some from the menu first."
        return
    fi

    echo "Starting quiz..."
    echo "Enter your name:"
    read name

    echo "Hello $name"
    echo

    echo "Choose a category (or type ALL):"
    cut -d'|' -f1 "$QUESTIONS_FILE" | sort | uniq
    read chosen_category
    chosen_category=$(echo "$chosen_category" | tr 'a-z' 'A-Z')

    echo "Choose difficulty (easy/medium/hard or ALL):"
    read chosen_difficulty
    chosen_difficulty=$(echo "$chosen_difficulty" | tr 'a-z' 'A-Z')
    echo

    while IFS='|' read category difficulty question a b c d correct
    do
        category_upper=$(echo "$category" | tr 'a-z' 'A-Z')
        difficulty_upper=$(echo "$difficulty" | tr 'a-z' 'A-Z')

        if [ "$chosen_category" != "ALL" ] && [ "$category_upper" != "$chosen_category" ]; then
            continue
        fi

        if [ "$chosen_difficulty" != "ALL" ] && [ "$difficulty_upper" != "$chosen_difficulty" ]; then
            continue
        fi

        found=1

        echo "Question: $question"
        echo "A) $a"
        echo "B) $b"
        echo "C) $c"
        echo "D) $d"

        echo "Your answer:"
        read answer </dev/tty

        answer=$(echo "$answer" | tr 'a-z' 'A-Z')

        if [ "$answer" = "$correct" ]; then
            echo "Correct!"
            score=$((score + 1))
        else
            echo "Wrong! Correct answer is $correct"
        fi

        total=$((total + 1))
        echo
    done < "$QUESTIONS_FILE"

    if [ $found -eq 0 ]; then
        echo "No questions found for that category/difficulty."
        return
    fi

    echo "Quiz finished!"
    echo "Your score: $score/$total"
    echo "$name|$score|$total" >> "$SCORES_FILE"

    echo "Press Enter to return to menu"
    read dummy </dev/tty
}

view_scores() {
    echo "------ Scores ------"

    if [ ! -s "$SCORES_FILE" ]; then
        echo "No scores yet."
        return
    fi

    while IFS='|' read name score total
    do
        if [ -z "$name" ]; then
            continue
        fi

        if [ "$total" -gt 0 ]; then
            percentage=$((score * 100 / total))
        else
            percentage=0
        fi

        echo "$name - $score/$total ($percentage%)"
    done < "$SCORES_FILE"
}

add_question() {
    echo "Type cancel at any point to go back to the menu."

    echo "Enter category:"
    read category
    if [ "$category" = "cancel" ]; then
        return
    fi

    echo "Enter difficulty (easy/medium/hard):"
    read difficulty
    if [ "$difficulty" = "cancel" ]; then
        return
    fi

    echo "Enter question:"
    read question
    if [ "$question" = "cancel" ]; then
        return
    fi

    echo "Enter option A:"
    read a
    if [ "$a" = "cancel" ]; then
        return
    fi

    echo "Enter option B:"
    read b
    if [ "$b" = "cancel" ]; then
        return
    fi

    echo "Enter option C:"
    read c
    if [ "$c" = "cancel" ]; then
        return
    fi

    echo "Enter option D:"
    read d
    if [ "$d" = "cancel" ]; then
        return
    fi

    echo "Enter correct answer (A/B/C/D):"
    read correct
    if [ "$correct" = "cancel" ]; then
        return
    fi

    correct=$(echo "$correct" | tr 'a-z' 'A-Z')

    case "$correct" in
        A|B|C|D)
            echo "$category|$difficulty|$question|$a|$b|$c|$d|$correct" >> "$QUESTIONS_FILE"
            echo "Question added."
            ;;
        *)
            echo "Invalid answer. Question not saved."
            ;;
    esac
}

while true
do
    show_menu
    echo "Enter your choice:"
    read choice

    case $choice in
        1)
            start_quiz
            ;;
        2)
            view_scores
            ;;
        3)
            add_question
            ;;
        4)
            echo "Goodbye"
            exit
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac

    echo
done
