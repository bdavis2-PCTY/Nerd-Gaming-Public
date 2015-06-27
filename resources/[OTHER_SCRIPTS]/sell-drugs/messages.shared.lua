-- Don't change the '%s' in strings - they are for variables 

MESSAGES = { }
MESSAGES.SERVER = { }
MESSAGES.CLIENT = { }
MESSAGES.SHARED = { }

MESSAGES.SERVER.ALREADY_DEALING = "You are already dealing drugs.";
MESSAGES.SERVER.CMD_STOP_SELLING = "stopselling";
MESSAGES.SERVER.NOT_SELLING = "You're not currently selling drugs";
MESSAGES.SERVER.ON_BEGIN_SELLING = "You are now selling drugs. Type /%s to stop selling.";
MESSAGES.SERVER.NO_LONGER_SELLING = "You're no longer selling drugs";
MESSAGES.SERVER.NOT_ENOUGH_MONEY = "Sorry, you don't have $%s";
MESSAGES.SERVER.ON_SALE_DEALER = "%s has bought %s %s!";
MESSAGES.SERVER.ON_SALE_CLIENT = "You have bought %s %s from %s!";

MESSAGES.SHARED.DRUG_GOD = "God";
MESSAGES.SHARED.DRUG_WEED = "Weed";
MESSAGES.SHARED.DRUG_SPEED = 'Speed';
MESSAGES.SHARED.DRUG_LSD = "LSD";
MESSAGES.SHARED.DRUG_STEROIDS = "Steroids";
MESSAGES.SHARED.DRUG_HEROIN = "Heroin";

MESSAGES.CLIENT.COMMAND = "selldrugs";
MESSAGES.CLIENT.BEGIN_SELL = "Begin Selling";
MESSAGES.CLIENT.CANCEL = "Cancel";

MESSAGES.CLIENT.SETUP_WINDOW_ALREADY_OPEN = "The setup window is already open";
MESSAGES.CLIENT.SETUP_NOT_NUMBERS = "Please enter valid numbers [0-infinite]";
MESSAGES.CLIENT.SETUP_INVALID_AMOUNT = "You don't have %s of the '%s' drug.";
MESSAGES.CLIENT.NOT_WHOLE = "All numbers must be integers (Whole numbers)";
MESSAGES.CLIENT.AMOUNT = "Amount";
MESSAGES.CLIENT.PRICE_UNIT = "Price/Unit"
MESSAGES.CLIENT.TOTAL = "Total"

MESSAGES.CLIENT.CANNOT_SELL_BUYING = "You cannot sell drugs while buying them";