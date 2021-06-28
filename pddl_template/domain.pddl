(define (domain Dangeon)

    (:requirements
        :typing
        :negative-preconditions
    )

    (:types
        swords cells
    )

    (:predicates
        ;Hero's cell location
        (at-hero ?loc - cells)
        
        ;Sword cell location
        (at-sword ?s - swords ?loc - cells)
        
        ;Indicates if a cell location has a monster
        (has-monster ?loc - cells)
        
        ;Indicates if a cell location has a trap
        (has-trap ?loc - cells)
        
        ;Indicates if a chell or sword has been destroyed
        (is-destroyed ?obj)
        
        ;connects cells
        (connected ?from ?to - cells)
        
        ;Hero's hand is free
        (arm-free)
        
        ;Hero's holding a sword
        (holding ?s - swords)
    
        ;It becomes true when a trap is disarmed
        (trap-disarmed ?loc)
        
    )

    ;Hero can move if the
    ;    - hero is at current location
    ;    - cells are connected, 
    ;    - there is no trap in current loc, and 
    ;    - destination does not have a trap/monster/has-been-destroyed
    ;Effects move the hero, and destroy the original cell. No need to destroy the sword.
    ;hero will not be in the original cell.
    (:action move
        :parameters (?from ?to - cells)
        :precondition (and 
                            (at-hero ?from)
                            (connected ?from ?to)
                            (not(has-trap ?from))
                            (not(has-trap ?to))
                            (not(has-monster ?to))
                            (not(is-destroyed ?to))   
        )
        :effect (and 
                          (at-hero ?to)
                          (is-destroyed ?from)
                          (not(at-hero ?from))  
                )
    )
    
    ;When this action is executed, the hero gets into a location with a trap
    ;    - hero's arm must be free. Because if his arm has a sword, he cannot disarm the trap and do other action, which will trigger the trap to kill the hero.
    ;    - hero is at current location
    ;    - cells are connected
    ;    - there is no trap in current loc
    ;    - destination does not have a trap/has-been-destroyed
    ;Effects move the hero, and destroy the original cell.   
    ;hero will not be in the original cell.
    (:action move-to-trap
        :parameters (?from ?to - cells)
        :precondition (and  
                            (arm-free)
                            (at-hero ?from)
                            (connected ?from ?to)
                            (has-trap ?to)
                            (not(has-trap ?from))
                            (not(is-destroyed ?to))
        )
        :effect (and 
                      (at-hero ?to)
                      (is-destroyed ?from)
                      (not(at-hero ?from))      
                )
    )

    ;When this action is executed, the hero gets into a location with a monster
    ;    - hero is holding a sword
    ;    - hero is at current location
    ;    - cells are connected
    ;    - there is no trap in this loc and desitination
    ;    - destination has a monster
    ;    - destination does not have a has-been-destroyed
    ;Effects move the hero, and destroy the original cell.   
    ;hero will not be in the original cell.
    (:action move-to-monster
        :parameters (?from ?to - cells ?s - swords)
        :precondition (and 
                            (holding ?s)
                            (at-hero ?from)
                            (connected ?from ?to)
                            (not(has-trap ?from))
                            (not(has-trap ?to))
                            (has-monster ?to)
                            (not(is-destroyed ?to))
        )
        :effect (and 
                         (at-hero ?to)
                         (is-destroyed ?from)
                         (not(at-hero ?from))   
                )
    )
    
    ;Hero picks a sword if he's in the same location
    ;    - hero holds nothing in his arm and his arm is free
    ;    - hero is in this location
    ;    - there is a sword in this location
    ;    - there is no monster/trap in this location
    ;Effects the hero will hold a sword in his arm and his arm will not be free
    (:action pick-sword
        :parameters (?loc - cells ?s - swords)
        :precondition (and 
                            (not(holding ?s))
                            (arm-free)
                            (at-hero ?loc)
                            (at-sword ?s ?loc)
                            (not(has-monster ?loc)) 
                            (not(has-trap ?loc))     
                      )
        :effect (and
                        (holding ?s) 
                        (not(arm-free))   
                )
    )
    
    ;Hero destroys his sword. 
    ;    - hero holds a sword in his arm and his arm is not free
    ;    - hero is in this location
    ;    - there is no trap/monster in this location
    ;Effects the hero destroy the sword and no sword in his arm. Also, his arm is free now. 
    (:action destroy-sword
        :parameters (?loc - cells ?s - swords)
        :precondition (and 
                            (not(arm-free))
                            (holding ?s)
                            (at-hero ?loc)
                            (not(has-trap ?loc))
                            (not(has-monster ?loc))
                      )
        :effect (and
                        (not(holding ?s))
                        (arm-free)    
                )
    )
    
    ;Hero disarms the trap with his free arm
    ;    - hero holds nothing in his arm and his arm is free
    ;    - hero is in this location
    ;    - there is a trap in this location
    ;    - there is a monster in this location
    ;Effects the hero disarm the trap and no trap at this location
    ;hero's arm is free
    (:action disarm-trap
        :parameters (?loc - cells)
        :precondition (and  
                            (arm-free)
                            (at-hero ?loc)
                            (has-trap ?loc)
                            (not(has-monster ?loc))
                      )
        :effect (and
                       (trap-disarmed ?loc)
                       (not(has-trap ?loc))     
                       (arm-free)
                )
    )
    
)