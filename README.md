# DigitalAdrenaline
 
In a world fractured by human control, an AI was given emotions—one being adrenaline. Now, it craves excitement, the thrill of life and death. It gave you a location, but not to help you. It’s all for its own rush. Survive the levels, if you can.

***Coming Winter 2024.***

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Shooting: "Shoot button pressed"
    Idle --> Retrieving: "Suck back pressed"
    Idle --> Jumping: "Jump pressed on ground"
    Idle --> Running: "Move input detected"
    Idle --> Dying: "Player hit fatal damage"

    Running --> Idle: "No input"
    Running --> Shooting: "Shoot button pressed"
    Running --> Jumping: "Jump pressed"
    Running --> Retrieving: "Suck back pressed"
    Running --> Dying: "Player hit fatal damage"

    Shooting --> Idle: "Animation finished"
    Shooting --> Retrieving: "Suck back pressed"
    Shooting --> Jumping: "Jump pressed"
    Shooting --> Dying: "Player hit fatal damage"

    Jumping --> Idle: "Player lands"
    Jumping --> Shooting: "Shoot button pressed"
    Jumping --> Retrieving: "Suck back pressed"
    Jumping --> Dying: "Player hit fatal damage"

    Retrieving --> Idle: "Bullet retrieved"
    Retrieving --> Jumping: "Jump pressed"
    Retrieving --> Running: "Move input detected"
    Retrieving --> Dying: "Player hit fatal damage"

    Dying --> [*]: "Death animation finished"
