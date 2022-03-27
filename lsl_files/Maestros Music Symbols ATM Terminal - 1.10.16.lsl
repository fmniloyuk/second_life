
string url = "http://178.128.46.187/";

// integer debugIsOn = FALSE; integer SCRIPT_DEBUG_CHANNEL = -20210000; listenDebug() { llListen(SCRIPT_DEBUG_CHANNEL, "", NULL_KEY, ""); llSay(SCRIPT_DEBUG_CHANNEL, "??");} manageDebug(string cmd) { if (cmd != "??") debugIsOn = (cmd == "DEBUG_ON"); llWhisper(0, "DEBUG [" + llList2String(["OFF", "ON"], debugIsOn) + "]"); } debug(string s) { if (debugIsOn) llSay(0, "--------------- DEBUG:" + s); }
// listenDebug();
// if (SCRIPT_DEBUG_CHANNEL == ch) manageDebug(message);

float currentDBBalance;
integer currentBalance;
key withdraw;
key currentUser = NULL_KEY;
integer counter = 0;
integer channel = 0;

init()
{
    channel = llFloor(llFrand(934978)+83222);    
    
    updateText();
}

actionText(string s) { llSetText(s, <1,0.5,0>, 1); }

updateText()
{
    if (currentUser != NULL_KEY)
    {
        string progress;
        if (counter != 0)
        {
            progress = "\n \n" + llGetSubString("██████████", 0, 10-counter) + 
                llGetSubString("░░░░░░░░░░", 10-counter, 10);        
        }
        
        llSetText("Current ATM is used by \n" + llKey2Name(currentUser) + "..." + progress,
            <1,1,1>, 1); 
    }    
    else
    {
        llSetText("Current ATM is available.\n \nPlease touch to cash out...", <1,1,1>, 1); 
    }
}

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
    return llHTTPRequest(req, [], "");
}

key findRegisterReq;
findRegister(key avatarKey)
{
    debug("findRegister");
    actionText("Checking your account...");
    findRegisterReq = doHttpRequest("register_CRU.php", ["action", "Read", "avatar_key", avatarKey]);
}

integer listenId;

resetUsage()
{
    currentUser = NULL_KEY;
    counter = 0;
    llSetTimerEvent(0);
    llListenRemove(listenId);
    updateText();
}

key updateMoneyReq;
updateMoney(key avatarKey, float moneyValue)
{
    debug("updateMoney");
    updateMoneyReq = doHttpRequest("register_CRU.php", 
        ["action", "UpdateXpAndMoney", 
        "avatar_key", avatarKey, 
        "amount", (string) moneyValue, 
        "experience", "+0", 
        "total_amount", "+0"]);
}

default
{
    // on_rez( integer start_param ){ ; }
    // Triggered when an object is rezzed (by script or by user). Also triggered in attachments when a user logs in, or when the object is attached from inventory.
    on_rez(integer param) { llResetScript(); }    
    state_entry() 
    { 
        actionText("Please grant DEBIT permissions...");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT); 
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_DEBIT)
            state running;
        else
            llOwnerSay("Please grant DEBIT permissions...");
    }
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner())
             llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
}

state running
{
    // on_rez( integer start_param ){ ; }
    // Triggered when an object is rezzed (by script or by user). Also triggered in attachments when a user logs in, or when the object is attached from inventory.
    on_rez(integer param) { llResetScript(); } 
        
    state_entry()
    {
        listenDebug();

        init();
    }
    
    touch_start(integer total_number)
    {
        if (currentUser != NULL_KEY) llRegionSayTo(llDetectedKey(0),0,"Sorry you cannot use this ATM, busy at the moment..");
        
        else if (llDetectedGroup(0) == 0)
            llSay(0,"Sorry you cannot use this ATM, because of belonging to a different group... Please join The Maestros Music Symbols Group.");
        
        else
        {
            currentUser = llDetectedKey(0);
            actionText("Looking for " + llKey2Name(currentUser) + " account ...");

            findRegister(currentUser);
       }
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
                llRegionSayTo(currentUser, 0, "Sorry but you are not registered in our system."); 
                resetUsage();
            }
            else
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
                    if (k == "amount") 
                    {
                        currentDBBalance = (float) v;
                        currentBalance = (integer) v;
                    }
                }
                
                if (currentBalance < 1)
                {
                    llRegionSayTo(currentUser,0,"Sorry... You do not have enough balance to withdraw any L$! ");
                    resetUsage();
                }
                else
                {
                    llListenRemove(listenId);
                    listenId = llListen(channel,"", currentUser,"");
                    llDialog(currentUser,"\nYou have "+(string)currentBalance+" L$ in your account.\n \nPlease confirm to withdraw amount in 10 seconds",
                        ["Confirm"],channel);
                    counter = 10;
                    // llSetTimerEvent( float sec );
                    // Cause the timer event to be triggered a maximum of once every sec seconds. Passing in 0.0 stops further timer events.
                    llSetTimerEvent(1);
                } 
            }
        }
           
        if (updateMoneyReq == request_id)
        {
            list resp = llParseString2List(body, ["\n"], []);
            string ans = llList2String(resp, 0);
            
            if ("UPDATED" == ans)
            {
                if ((string) llGetOwner() == "59992c57-4d1e-4f43-a0c4-6dc8ec37d665")
                    debug("DEBUG : Money not sent");    
                else
                    llGiveMoney(currentUser, currentBalance);
                    
                llRegionSayTo(currentUser, 0, "Thank you.. "+
                    (string) currentBalance + " L$ were sent successfully...");                 
            }
            else
                llOwnerSay("Something went wrong.. please try after some time....");
                
            resetUsage();
        }
    }
        
    listen(integer ch, string name, key id, string message)
    {
        if (SCRIPT_DEBUG_CHANNEL == ch) manageDebug(message);
        
        if (ch == channel)
        {
            if (message == "Confirm")
            { 
                // llSetTimerEvent( float sec );
                // Cause the timer event to be triggered a maximum of once every sec seconds. Passing in 0.0 stops further timer events.
                llSetTimerEvent(10);
                float moneyValue = (float) currentDBBalance - (float) currentBalance;
                updateMoney(currentUser, moneyValue);
            }
        }
    } 
    
    timer()
    {
        counter--;
        
        if (counter == 0)
            resetUsage();
        else
            updateText();
    }
 }
