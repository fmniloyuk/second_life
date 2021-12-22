
string url = "http://165.22.114.113/";

integer debugIsOn = FALSE; integer SCRIPT_DEBUG_CHANNEL = -20210000; listenDebug() { llListen(SCRIPT_DEBUG_CHANNEL, "", NULL_KEY, ""); llSay(SCRIPT_DEBUG_CHANNEL, "??");} manageDebug(string cmd) { if (cmd != "??") debugIsOn = (cmd == "DEBUG_ON"); llWhisper(0, "DEBUG [" + llList2String(["OFF", "ON"], debugIsOn) + "]"); } debug(string s) { if (debugIsOn) llSay(0, "--------------- DEBUG:" + s); }

key buyer = NULL_KEY;
integer booster = 0;
integer amount = 0;
key mowner = "ccb679d9-690e-4b6c-a7eb-769712f1d0aa";
key taxowner = "ccb679d9-690e-4b6c-a7eb-769712f1d0aa";

integer KIOSK_CHANNEL = 2021091853;

string type =  "Undefined";

list prices = [];
list apprenticePrices = [5, 10, 15, 20];
list professionalPrices = [10 ,15, 20, 25];
list maestroPrices = [20 ,25, 30, 35];

list boosters = [8, 16, 24, 36];

integer contains(string source, string tag) { return llSubStringIndex(source, tag) != -1; }

integer boosterCounterM = 0;
integer boosterCounterA = 0;
integer boosterCounterP = 0;

integer flag = 0;

key doHttpRequest(string php, list params)
{
    string paramsAsString = "";
    integer i;
    integer size = llGetListLength(params);
    for(i=0; i < size; i+=2)
    {
        string and = "";
        if (i != 0) and = "&";
        paramsAsString = paramsAsString + and + llList2String(params, i) + "=" + llEscapeURL(llList2String(params, i+1));
    }
    string req = url+php+"?"+paramsAsString;
    // debug(req);
    return llHTTPRequest(req, [], "");
}

initFromType()
{
    string name = llGetObjectName();
    
    if (contains(name, "*Apprentice*"))
    {
        type = "Apprentice";
        prices = apprenticePrices;
    }
    
    if (contains(name, "*Professional*")) 
    {
        type = "Professional";
        prices = professionalPrices;
    }
    
    if (contains(name, "*Maestro*")) 
    {
        type = "Maestro";
        prices = maestroPrices;
    }
}

actionText(string s) { llSetText(s, <1,1,0>, 1); }

key findRegisterReq;
findRegister(key avatarKey)
{
    debug("findRegister");
    actionText("Checking your account...");
    findRegisterReq = doHttpRequest("register_CRU.php", ["action", "Read", "avatar_key", avatarKey]);
}

key updateRegisterPropertiesReq;
updateRegisterProperties(key userKey, string properties)
{
    debug("updateProperties");
    actionText("Updating...");
    updateRegisterPropertiesReq = doHttpRequest("register_CRU.php", 
        ["action", "UpdateProperties", "avatar_key", userKey, "properties", properties]);
}

updateProperties(key user)
{
   updateRegisterProperties(user, llList2CSV([boosterCounterA,boosterCounterP,boosterCounterM]));    
}

key currentUser;
integer boosterIncrement;

noText() { 
    //llSetText( string text, vector color, float alpha );
    // Displays text that hovers over the prim with specific color and translucency (specified with alpha).
    llSetText("", <1,1,1>, 1); 
}

manageUpdatingEBC()
{
    if (type == "Apprentice") boosterCounterA += boosterIncrement;
    else if (type == "Professional") boosterCounterP += boosterIncrement;
    else if (type == "Maestro") boosterCounterM += boosterIncrement;
    else llOwnerSay("TYPE NOT MANAGED !!!!");
    
    updateProperties(currentUser);
}

integer INFO = 0;
integer PAYMENT_DONE = 1;

integer step = INFO;

default
{
    // on_rez( integer start_param ){ ; }
    // Triggered when an object is rezzed (by script or by user). Also triggered in attachments when a user logs in, or when the object is attached from inventory.
    on_rez(integer param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        initFromType();
        
        if (type == "Undefined")
            llOwnerSay("Kiosk is not well named... NOT WORKING.");
        else
        {
            llOwnerSay("Kiosk for '"+ type + "' boosters is starting. Please allow Debit permission...");
            
            //llSetPayPrice( integer price, list quick_pay_buttons );
            // Suggest default amounts for the pay text field and pay buttons of the appearing dialog when someone chooses to pay this object.
            llSetPayPrice(PAY_HIDE, [PAY_HIDE ,PAY_HIDE, PAY_HIDE, PAY_HIDE]);
            
            // llRequestPermissions( key agent, integer permissions );
            // PERMISSION_DEBIT => take money from agent's account	
            llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        }
    }
    
    // Triggered when an agent grants run time permissions to this script.
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_DEBIT)
            state cash;
    }
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner())
             llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
}
    
// cash state
state cash
{
    // on_rez( integer start_param ){ ; }
    // Triggered when an object is rezzed (by script or by user). Also triggered in attachments when a user logs in, or when the object is attached from inventory.
    on_rez(integer param) 
    {
        llResetScript();
    }
    
    state_entry()
    { 
        //llSetPayPrice( integer price, list quick_pay_buttons );
        // Suggest default amounts for the pay text field and pay buttons of the appearing dialog when someone chooses to pay this object.
        llSetPayPrice(PAY_HIDE, prices);
        llOwnerSay("Activated");
        
        listenDebug();
        
        noText();
    }
    
    touch_start(integer total_number)
    {
        llRegionSayTo(llDetectedKey(0),0,"Right click and pay to recharge...");
    }
    
    money(key id, integer price)
    {        
        // integer llListFindList( list src, list test );
        // Returns the integer index of the first instance of test in src.
        integer index = llListFindList(prices, [price]);
        if (index != -1) booster = llList2Integer(boosters, index);
        else booster = 1;
        
        if ((string) llGetOwner() == "59992c57-4d1e-4f43-a0c4-6dc8ec37d665")
            debug("DEBUG : Money not sent");    
        else
            llGiveMoney(mowner,(integer)(price));
            
        llRegionSayTo(id,0,(string)booster +" " + type + " boosters were added to your account. Thank you..");
        
        currentUser = id;
        boosterIncrement = booster;
        
        step = PAYMENT_DONE;
        findRegister(currentUser);
    }
    
    listen(integer channel, string name, key k, string message)
    {
        if (SCRIPT_DEBUG_CHANNEL == channel) manageDebug(message);
    }
    
    //Triggered when task receives a response to one of its llHTTPRequests
    http_response(key request_id, integer status, list metadata, string body)
    {
        debug((string) status + " " + body);
        
        if (findRegisterReq == request_id)
        {
            list resp = llParseString2List(body, ["\n"], []);
            string ans = llList2String(resp, 0);
            
            if ("NOT FOUND" == ans)
            {
                llOwnerSay("You are not registered.");    
            }
            else if ("FOUND" == ans)
            {
                integer i;
                integer size = llGetListLength(resp);
                string stats = "";
                for(i=0; i < size; i++)
                {
                    string attr = llList2String(resp, i);
                    integer index = llSubStringIndex(attr, ":");
                    string k = llGetSubString(attr, 0, index-1);
                    string v = llGetSubString(attr, index+1, -1);
                    if (k == "registration_date") stats = stats + " - Registration: " + v;
                    if (k == "amount") stats = stats + " - L$: " + v;
                    if (k == "experience") stats = stats + " - XP: " + v;
                    if (k == "total_amount") stats = stats + " - Total L$: " + v;
                    if (k == "properties")
                    {
                        list l = llCSV2List(v);
                        boosterCounterA = llList2Integer(l, 0);
                        boosterCounterP = llList2Integer(l, 1);
                        boosterCounterM = llList2Integer(l, 2);                                       }
                }
                
                if (step == INFO)
                    llRegionSayTo(currentUser, 0, "Your stats are " + stats + " / Boosters: Apprentice:" + (string) boosterCounterA + " - " + "Professional:" + (string) boosterCounterP + " - " + "Maestro:" + (string) boosterCounterM); 
                else
                    manageUpdatingEBC();
                    
                step = INFO;
            }
        } 
        
        if (updateRegisterPropertiesReq == request_id)
        {
            findRegister(currentUser);
                        
            noText();    
        }
    }   
}
