string url = "http://165.22.114.113/";
 
integer debugIsOn = FALSE; integer SCRIPT_DEBUG_CHANNEL = -20210000; listenDebug() { llListen(SCRIPT_DEBUG_CHANNEL, "", NULL_KEY, ""); llSay(SCRIPT_DEBUG_CHANNEL, "??");} manageDebug(string cmd) { if (cmd != "??") debugIsOn = (cmd == "DEBUG_ON"); llWhisper(0, "DEBUG [" + llList2String(["OFF", "ON"], debugIsOn) + "]"); } debug(string s) { if (debugIsOn) llSay(0, "--------------- DEBUG:" + s); }

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
    //llOwnerSay(req);
    return llHTTPRequest(req, [], "");
}

key findRegisterReq;

findRegister(key avatarKey)
{
    debug("findRegister");
    findRegisterReq = doHttpRequest("register_CRU.php", ["action", "Read", "avatar_key", avatarKey]);
}

key updateLastVotingReq;
updateLastVotingFor(key avatarKey, integer vote)
{
    debug("updateLastVotingReq");
    updateLastVotingReq = doHttpRequest("register_CRU.php", 
        ["action", "UpdateLastVoting", "avatar_key", avatarKey, "last_voting", vote]);
}

integer VOTE_TO_STAND_CHANNEL = 202110011;
integer STAND_TO_VOTE_CHANNEL = 202110012;

key stand;

integer step;
integer RUNNING = 0;
integer CHECKING = 1;
integer WAITING_FOR_ANSWER_FROM_STAND = 2;

integer isActive;

checkForActiveStand()
{
    step = WAITING_FOR_ANSWER_FROM_STAND;
    llRegionSay(VOTE_TO_STAND_CHANNEL, 
        llDumpList2String([ "CheckSameOwnerAndParcel", 
                            llGetOwner(), 
                            llList2String(llGetParcelDetails(
                                              llGetPos(), 
                                              [PARCEL_DETAILS_ID]), 0)], "¥"));
    llSetTimerEvent(5);
}

update()
{
    if (isActive)
    {
        step = RUNNING;
        llSetText("Please touch this \nVoting station \nfor your weekly vote", <1,1,1>, 1);
    }
    else
    {
        step = CHECKING;
        llSetText("No active Maestro stand\nfound on this parcel\n \nVoting is DISABLED.", <1,0,0>, 1);
    }            
}

integer DAY;
key toucher = NULL_KEY;

default
{
    // on_rez( integer start_param ){ ; }
    // Triggered when an object is rezzed (by script or by user). Also triggered in attachments when a user logs in, or when the object is attached from inventory.
    on_rez(integer p) { llResetScript(); }
    
    state_entry()
    {
        llSetText("", <1,1,1>, 1);
        llListen(STAND_TO_VOTE_CHANNEL, "", NULL_KEY, "");
        
        DAY = 3600 * 24; 
        
        listenDebug();
        
        // llSetTimerEvent( float sec );
        // Cause the timer event to be triggered a maximum of once every sec seconds. Passing in 0.0 stops further timer events.
        llSetTimerEvent(5);
        checkForActiveStand();               
    }   
    
    touch_start(integer nb)
    {
        key who = llDetectedKey(0);
        if (toucher != NULL_KEY) 
            llRegionSayTo(who, 0, "The voting box is used by an other player. Please try in some seconds.");    
        else
        {
            toucher = who; 
            findRegister(toucher);   
        }
    }
    
    timer()
    {
        if (step == CHECKING) 
            checkForActiveStand();
            
        else if (step == WAITING_FOR_ANSWER_FROM_STAND)
        {
            isActive = FALSE;  
            update();  
        }   
    }
    
    listen(integer channel, string name, key k, string msg)
    {
        if (SCRIPT_DEBUG_CHANNEL == channel) { manageDebug(msg); return; }
        
        debug(msg);
        list l = llParseString2List(msg, ["¥"], []);
        string cmd = llList2String(l, 0);
            
        if ("MaestroStand" == cmd) 
        {
            isActive = llList2Float(l, 1) != 0;
            if (isActive) stand = k;
            update();
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
                llRegionSayTo(toucher, 0, "You are not a registered user, you are not able to vote.");
                toucher = NULL_KEY;                    
            }
            else
            {
                integer lastVoting;
                integer i;
                integer size = llGetListLength(resp);
                string stats = "";
                for(i=0; i < size; i++)
                {
                    string attr = llList2String(resp, i);
                    integer index = llSubStringIndex(attr, ":");
                    string k = llGetSubString(attr, 0, index-1);
                    string v = llGetSubString(attr, index+1, -1);
                    if (k == "last_voting") lastVoting = (integer) v;
                }
                
                integer diff = llGetUnixTime() - lastVoting;
                
                if (FALSE && diff < 7 * DAY) llRegionSayTo(toucher, 0, "You can vote only each 7 days.");
                else
                {
                    llRegionSayTo(toucher, 0, "Your vote is recorded. Thx a lot for voting for our place !!!");
                    updateLastVotingFor(toucher, llGetUnixTime());
                    
                    llRegionSayTo(stand, VOTE_TO_STAND_CHANNEL, "OneMoreVote");       
                }
                
                toucher = NULL_KEY;
            }
        }
    }
}