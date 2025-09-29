extends Node

signal AddContentement(amount: float)
signal spawn_popup_requested
signal OpenEvent(event: EventResource, district: District, popup: PopupEvent)
signal AskForEvent(popup: PopupEvent)
signal EpidemicEnding
signal RevolutionEnding
signal GoodEnding
signal UnlockEvent(event: EventResource)
signal RemoveEvent(event: EventResource)
signal AddYear(amount: int)
signal PlaySound(sound: Enums.Sound)
signal CheckGameOver
