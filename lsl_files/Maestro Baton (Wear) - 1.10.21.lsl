// Debug starts 
integer debugIsOn = FALSE; 
integer SCRIPT_DEBUG_CHANNEL = -20210000; 

listenDebug() { 
    llListen(SCRIPT_DEBUG_CHANNEL, "", NULL_KEY, ""); 
    // llSay(SCRIPT_DEBUG_CHANNEL, "??");
    } 
    
    manageDebug(string cmd) 
    { if (cmd != "??") 
        debugIsOn = (cmd == "DEBUG_ON"); 
        // llWhisper(0, "DEBUG [" + llList2String(["OFF", "ON"], debugIsOn) + "]"); 
    } 
    
    debug(string s) { 
        if (debugIsOn) llSay(0, "--------------- DEBUG:" + s); 
    }
// Debug ends

// listenDebug();
// if (SCRIPT_DEBUG_CHANNEL == ch) manageDebug(message);

integer HUD_CHANNEL         = 2021091821;
integer KIOSK_CHANNEL       = 2021091853;
integer BATON_CHANNEL       = 2021091801;
integer BATON_REPLY_CHANNEL = 2021091808;

integer batonType;

integer NONE = 0;
integer APPRENTICE = 1;
integer P = 2;
integer M = 3;

integer timeinterval = 0;
integer count = 0;
key standId = NULL_KEY;

integer timestarted = 0;  
integer totalplay = 0;


string url = "https://thesecondlife.herokuapp.com/";

key rezreq;

string selected;

string boosterm;
integer boosterCounterM = 0;
integer boostertimem = 0;

string boostera;
integer boosterCounterA = 0;
integer boostertimea = 0;

string boosterp;
integer boosterCounterP = 0;
integer boostertimep = 0;
integer flag = 0;

integer timeleft = 0;
integer gmt = 0; 

integer DAYS_PER_YEAR        = 365;           // Non leap year
integer SECONDS_PER_YEAR     = 31536000;      // Non leap year
integer SECONDS_PER_DAY      = 86400;
integer SECONDS_PER_HOUR     = 3600;
integer SECONDS_PER_MINUTE   = 60;
integer timercount = 0;
integer boosterflag = 0;
list MonthNameList = [  "JAN", "FEB", "MAR", "APR", "MAY", "JUN", 
                        "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" ];
integer allowed_conduct = TRUE;
string allowed_conduct_reason = "";
// This leap year test works for all years from 1901 to 2099 (yes, including 2000)
// Which is more than enough for UnixTime computations, which only operate over the range [1970, 2038].  (Omei Qunhua)
integer LeapYear( integer year)
{
    return !(year & 3);
}
 
integer DaysPerMonth(integer year, integer month)
{
    // Compact Days-Per-Month algorithm. Omei Qunhua.
    if (month == 2)      return 28 + LeapYear(year);
    return 30 + ( (month + (month > 7) ) & 1);           // Odd months up to July, and even months after July, have 31 days
}
 
integer DaysPerYear(integer year)
{
    return 365 + LeapYear(year);
}
 
///////////////////////////////////////////////////////////////////////////////////////
// Convert Unix time (integer) to a Date and Time string
///////////////////////////////////////////////////////////////////////////////////////
 
/////////////////////////////// Unix2DataTime() ///////////////////////////////////////
 
list Unix2DateTime(integer unixtime)
{
    integer days_since_1_1_1970     = unixtime / SECONDS_PER_DAY;
    integer day = days_since_1_1_1970 + 1;
    integer year  = 1970;
    integer days_per_year = DaysPerYear(year);
 
    while (day > days_per_year)
    {
        day -= days_per_year;
        ++year;
        days_per_year = DaysPerYear(year);
    }
 
    integer month = 1;
    integer days_per_month = DaysPerMonth(year, month);
 
    while (day > days_per_month)
    {
        day -= days_per_month;
 
        if (++month > 12)
        {    
            ++year;
            month = 1;
        }
 
        days_per_month = DaysPerMonth(year, month);
    }
 
    integer seconds_since_midnight  = unixtime % SECONDS_PER_DAY;
    integer hour        = seconds_since_midnight / SECONDS_PER_HOUR;
    integer second      = seconds_since_midnight % SECONDS_PER_HOUR;
    integer minute      = second / SECONDS_PER_MINUTE;
    second              = second % SECONDS_PER_MINUTE;
 
    return [ year, month, day, hour, minute, second ];
}
 
///////////////////////////////// MonthName() ////////////////////////////
 
string MonthName(integer month)
{
    if (month >= 0 && month < 12)
        return llList2String(MonthNameList, month);
    else
        return "";
}
 
///////////////////////////////// DateString() ///////////////////////////
 
string DateString(list timelist)
{
    integer year       = llList2Integer(timelist,0);
    integer month      = llList2Integer(timelist,1);
    integer day        = llList2Integer(timelist,2);
 
    return (string)(day) + "-" + MonthName(month - 1) + "-" + (string)year;
}
 
///////////////////////////////// TimeString() ////////////////////////////
 
string TimeString(list timelist)
{
    string  hourstr     = llGetSubString ( (string) (100 + llList2Integer(timelist, 3) ), -2, -1);
    string  minutestr   = llGetSubString ( (string) (100 + llList2Integer(timelist, 4) ), -2, -1);
    string  secondstr   = llGetSubString ( (string) (100 + llList2Integer(timelist, 5) ), -2, -1);
    return  hourstr + ":" + minutestr + ":" + secondstr;
}
 
///////////////////////////////////////////////////////////////////////////////
// Convert a date and time to a Unix time integer
///////////////////////////////////////////////////////////////////////////////
 
////////////////////////// DateTime2Unix() ////////////////////////////////////
 
integer DateTime2Unix(integer year, integer month, integer day, integer hour, integer minute, integer second)
{
    integer time = 0;
    integer yr = 1970;
    integer mt = 1;
    integer days;
 
    while(yr < year)
    {
        days = DaysPerYear(yr++);
        time += days * SECONDS_PER_DAY;
    }
 
    while (mt < month)
    {
        days = DaysPerMonth(year, mt++);
        time += days * SECONDS_PER_DAY;
    }
 
    days = day - 1;
    time += days * SECONDS_PER_DAY;
    time += hour * SECONDS_PER_HOUR;
    time += minute * SECONDS_PER_MINUTE;
    time += second;
 
    return time;
}
//////////////////////////////////////////////
// End Unix2DateTimev1.0.lsl
//////////////////////////////////////////////

list uUnix2StampLst( integer vIntDat ){
    if (vIntDat / 2145916800){
        vIntDat = 2145916800 * (1 | vIntDat >> 31);
    }
    integer vIntYrs = 1970 + ((((vIntDat %= 126230400) >> 31) + vIntDat / 126230400) << 2);
    vIntDat -= 126230400 * (vIntDat >> 31);
    integer vIntDys = vIntDat / 86400;
    list vLstRtn = [vIntDat % 86400 / 3600, vIntDat % 3600 / 60, vIntDat % 60];
 
    if (789 == vIntDys){
        vIntYrs += 2;
        vIntDat = 2;
        vIntDys = 29;
    }else{
        vIntYrs += (vIntDys -= (vIntDys > 789)) / 365;
        vIntDys %= 365;
        vIntDys += vIntDat = 1;
        integer vIntTmp;
        while (vIntDys > (vIntTmp = (30 | (vIntDat & 1) ^ (vIntDat > 7)) - ((vIntDat == 2) << 1))){
            ++vIntDat;
            vIntDys -= vIntTmp;
        }
    }
    return [vIntYrs, vIntDat, vIntDys] + vLstRtn;
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/

integer gIntMinute = 60;    //-- 1 minute in seconds
integer gIntHour   = 3600;  //-- 1 hour in seconds
integer gInt12Hr   = 43200; //-- 12hrs in seconds
integer gIntDay    = 86400; //-- 1 day in seconds
 
string fStrGMTwOffset( integer vIntLocalOffset,integer gmtclock ){
   //-- get the correct time in seconds for the given offset
  //integer vIntBaseTime = ((integer)llGetGMTclock() + gIntDay + vIntLocalOffset * gIntHour) % gIntDay;
  integer vIntBaseTime = (gmtclock + gIntDay + vIntLocalOffset * gIntHour) % gIntDay;
  string vStrReturn;
 
   //-- store morning or night and reduce to 12hour format if needed
  if (vIntBaseTime < gInt12Hr){
    vStrReturn = " AM";
  }else{
    vStrReturn = " PM";
    vIntBaseTime = vIntBaseTime % gInt12Hr;
  }
 
   //-- get and format minutes
  integer vIntMinutes = (vIntBaseTime % gIntHour) / gIntMinute;
  vStrReturn = (string)vIntMinutes + vStrReturn;
  if (10 > vIntMinutes){
    vStrReturn = "0" + vStrReturn;
  }
 
   //-- add in the correct hour, force 0 to 12
  if (vIntBaseTime < gIntHour){
    vStrReturn = "12:" + vStrReturn;
  }else{
    vStrReturn = (string)(vIntBaseTime / gIntHour) + ":" + vStrReturn;
  }
  return vStrReturn;
}

string ConvertWallclockToTime(integer now)
{
    integer seconds = now % 60;
    integer minutes = (now / 60) % 60;
    integer hours = now / 3600;
    return llGetSubString("0" + (string)hours, -2, -1) + ":" 
        + llGetSubString("0" + (string)minutes, -2, -1) + ":" 
        + llGetSubString("0" + (string)seconds, -2, -1);
}
 
init()
{
    llSetText("", <1,1,1>, 0);
        
    llListen(BATON_CHANNEL,"","","");
    llListen(HUD_CHANNEL,"","","");
    llListen(KIOSK_CHANNEL, "","","");
    listenDebug();
        
    llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    
    initFromType();
    updateProperties();
    findRegister(llGetOwner(), INITIAL);
    llOwnerSay(llGetOwner());
}

stop()
{
    // llSetTimerEvent( float sec );
    // Cause the timer event to be triggered a maximum of once every sec seconds. Passing in 0.0 stops further timer events.
    llSetTimerEvent(0);
    llSetText("", <0,1,0>, 1);
    // standId = NULL_KEY;
}

string currentAnim;
string animToPlay;
string ebcToUse = "Maestro";

integer lastTakenBooster;

integer getOneMaestroBooster()
{
    boosterCounterM = boosterCounterM - 1;
    llOwnerSay("you have "+(string)boosterCounterM+" "+boosterm+" booster(s) left");  
    lastTakenBooster = M; 
    count = boostertimem;
    return boostertimem;     
}

integer getOneProfessionalBooster()
{
    boosterCounterP = boosterCounterP - 1;
    llOwnerSay("you have "+(string)boosterCounterP+" "+boosterp+" booster(s) left"); 
    lastTakenBooster = P;  
    count = boostertimep; 
    return boostertimep;     
}

integer getOneApprenticeBooster()
{
    boosterCounterA = boosterCounterA - 1;
    llOwnerSay("you have "+(string)boosterCounterA+" "+boostera+" booster(s) left");  
    lastTakenBooster = APPRENTICE;  
    count = boostertimea;
    return boostertimea;     
}

integer currentBooster;

start(string animation, integer countValue)
{   
    currentAnim = animation;    
    count = countValue;
    
    currentBooster = NONE;
    lastTakenBooster = NONE;
    
    integer prev = boosterCounterA + boosterCounterP + boosterCounterM;
    
    if (ebcToUse == "Any")
    {
        if (boosterCounterM > 0) count = getOneMaestroBooster();
        else if (boosterCounterP > 0) count = getOneProfessionalBooster();
        else if (boosterCounterA > 0) count = getOneApprenticeBooster();
    }
    else if (ebcToUse == "Maestro" && boosterCounterM > 0) count = getOneMaestroBooster();
    else if (ebcToUse == "Professional" && boosterCounterP > 0) count = getOneProfessionalBooster();
    else if (ebcToUse == "Apprentice" && boosterCounterA > 0) count = getOneApprenticeBooster();
    
    currentBooster = lastTakenBooster;
    
    llOwnerSay("You will receive your rewards in "+ (string)count+" Seconds...");
    llMessageLinked(LINK_THIS,23729,"start","");
    llStartAnimation(currentAnim);

    // llSetTimerEvent( float sec );
    // Cause the timer event to be triggered a maximum of once every sec seconds. Passing in 0.0 stops further timer events.
    llSetTimerEvent(1);
    
    // ebcToUse = "Any"; 
    
    if (prev != boosterCounterA + boosterCounterP + boosterCounterM)
        updateProperties();
}

list animations = ["Conducting 1", "Conducting 2", "Jazz conductor"];
integer MENU_CHANNEL = 88;
integer countValueToApply;
integer animMenuId;
integer currentMenu;
integer ANIMS = 0;

showAnimationMenu(integer countValue)
{
    currentMenu = ANIMS;
    count = 0;
    countValueToApply = countValue;
    
    list buttons = animations;
    if (batonType == P) buttons = llDeleteSubList(animations, -1, -1); 

    animMenuId = llListen(MENU_CHANNEL, "", llGetOwner(), "");
    debug("ANIMATION MENU DISPLAYED");    
    llDialog(llGetOwner(), "\nPlease choose the animation to play...", buttons, MENU_CHANNEL);
}

integer EBC = 1;
integer ebcMenuId;
showEBCMenu(list buttons)
{    
    currentMenu = EBC;
    ebcMenuId = llListen(MENU_CHANNEL, "", llGetOwner(), ""); 
    debug("EBC MENU DISPLAYED");       
    llDialog(llGetOwner(), "\nPlease choose the Booster to use...", buttons, MENU_CHANNEL);
}

integer contains(string source, string tag) { return llSubStringIndex(source, tag) != -1; }

integer XPImprovment;
integer maxNbTimes;

setParams(integer type, integer xp, integer nbTimes)
{
    batonType = type;
    XPImprovment = xp;
    maxNbTimes = nbTimes;
}

// Energy Boost Charges System - reduces countdown speed.
initFromType()
{
    string name = llGetObjectName();

    if (contains(name, "*Apprentice*")) setParams(APPRENTICE, 0, 36);
    if (contains(name, "*Professional*")) setParams(P, 4, 52);
    if (contains(name, "*Maestro*")) setParams(M, 14, 88);
    
    llOwnerSay("Baton's type : " + llList2String(["None", "Apprentice", "Professional", "Maestro"], batonType));
    
    boosterm =  "Maestro";
    boosterp =  "Professional";
    boostera =  "Apprentice";
    
    boostertimem = 32;
    boostertimep = 52;
    boostertimea = 88;
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
    // debug(req);
    return llHTTPRequest(req, [], "");
}

integer findingRegisterReason;
integer INITIAL = 0;
integer CHECK_BEFORE_CONDUCT = 1;
key findRegisterReq;
findRegister(key avatarKey, integer reason)
{
    debug("findRegister");
    // actionText("Checking your account...");
    findingRegisterReason = reason;
    findRegisterReq = doHttpRequest("register_CRU.php", ["action", "Read", "avatar_key", avatarKey]);
}

key createRegisterReq;
createRegister(key avatarKey)
{
    debug("createRegister");
    actionText("Creating your account...");
    createRegisterReq = doHttpRequest("register_CRU.php", 
        ["action", "Create", "avatar_key", avatarKey, "avatar_name", llKey2Name(avatarKey), 
         "registration_date", llGetDate(), "amount", 0, "experience", 0, "total_amount", 0]);
}

actionText(string s) { llSetText(s, <1,1,0>, 1); }
 
integer isKey(key in) { if (in) return TRUE; return (in == NULL_KEY); }

key updateRegisterPropertiesReq;
updateRegisterProperties(key userKey, string properties)
{
    debug("updateProperties");
    // actionText("Updating...");
    updateRegisterPropertiesReq = doHttpRequest("register_CRU.php", 
        ["action", "UpdateProperties", "avatar_key", userKey, "properties", properties]);
}

updateProperties()
{
   updateRegisterProperties(llGetOwner(), llList2CSV([boosterCounterA,boosterCounterP,boosterCounterM]));    
}

noText() {
     llSetText("", <1,1,1>, 1); 
    }
  
// Player can use only one type of Baton during any 24-hour time period.    
startIfAllowed(integer allowed, integer lastTime, string reason)
{
    allowed_conduct = allowed;
    if (allowed)
    {
        if(boosterCounterM > 0)
            llRegionSayTo(standId,BATON_REPLY_CHANNEL,"ihave"+","+(string)llGetOwner()+","+boosterm);
        else if(boosterCounterP > 0)
            llRegionSayTo(standId,BATON_REPLY_CHANNEL,"ihave"+","+(string)llGetOwner()+","+boosterp);
        else if(boosterCounterA > 0)
            llRegionSayTo(standId,BATON_REPLY_CHANNEL,"ihave"+","+(string)llGetOwner()+","+boostera);
        else
            llRegionSayTo(standId,BATON_REPLY_CHANNEL,"ihave"+","+(string)llGetOwner()+","+"");
                    
        timestarted = llGetUnixTime();
        // start("Jazz conductor", 5);
    }
    else
    {
        if (reason == "NBTIMES")
        {
            timeleft = lastTime + 86400;
            gmt = (integer)llGetGMTclock() - (llGetUnixTime() - lastTime);
            flag = 1;
            timercount =  lastTime+ 86400;
            llOwnerSay("Sorry, you have achieved your maximum today, you can return On "+(string)DateString(Unix2DateTime(timeleft))+ " "+ fStrGMTwOffset( -7 ,gmt));
            llRegionSayTo(standId,BATON_REPLY_CHANNEL,"maxreached"+","+(string)llGetOwner()+","+""); 
            llOwnerSay("Time remaining: "+ConvertWallclockToTime((timercount - llGetUnixTime())));
            allowed_conduct_reason = "Sorry, you have achieved your maximum today, you can return On "+(string)DateString(Unix2DateTime(timeleft))+ " "+ fStrGMTwOffset( -7 ,gmt);
        }
        else{
            allowed_conduct_reason = "Sorry but your started to conduct here with an other baton's type. " +
            "You can only use one baton per 24 hours per conduct locations.";
            llOwnerSay("Sorry but your started to conduct here with an other baton's type. " +
                       "You can only use one baton per 24 hours per conduct locations.");
        }
                       
        noText();
    }    
}

key findUsageReq;
findUsage(key userKey, key locationKey)
{
    // actionText("Checking for usage on this location...");
    debug("findUsage");
    findUsageReq = doHttpRequest("usage_CRU.php", 
        ["action", "Read", "user_key", userKey, "location_key", locationKey]);
}

key createUsageReq;
createUsage(key userKey, key locationKey, integer batonType, integer start, integer nbTimes)
{
    // actionText("Registering this usage...");
    debug("createUsage");
    createUsageReq = doHttpRequest("usage_CRU.php", 
        ["action", "Create", "user_key", userKey, "location_key", locationKey, 
         "baton_type", batonType, "start", start, "nb_times", nbTimes]);
}

key updateUsageReq;
updateUsage(key userKey, key locationKey, integer batonType, integer start, integer nbTimes)
{
    // actionText("Updating this usage...");
    debug("updateUsage");
    updateUsageReq = doHttpRequest("usage_CRU.php", 
        ["action", "UpdateBatonTypeAndStartAndNbTimes", "user_key", userKey, "location_key", locationKey, 
         "baton_type", batonType, "start", start, "nb_times", nbTimes]);
}

checkForUsage() 
{ 
    findUsage(llGetOwner(), currentParcel()); 
}
baton_touched(integer source)
{
    // if(!allowed_conduct){
    //     llOwnerSay(allowed_conduct_reason);
    //     return;
    // }
    key batonPlayer = llDetectedKey(0);
    if(source==0){
        if (llDetectedKey(0) != llGetOwner()){
            llRegionSayTo(batonPlayer, 0, "You have clicked another players Baton. This Maestro Baton is owned by "+llGetDisplayName(llGetOwner()));    
            return;
        }
    }


    if(standId == NULL_KEY){
        llRegionSayTo(batonPlayer, 0, "Please click Music Stand to begin play....");
        return;
    }
    key id = llDetectedKey(0);
    // llRegionSayTo(id, 0, "standId..."+(string)standId);
    list details = llGetObjectDetails(standId, ([OBJECT_DESC]));
    // llRegionSayTo(id, 0, "available money..."+(string)llList2String(details, 0));
    if((float)llList2String(details, 0) == 0.0) {
        llRegionSayTo(batonPlayer, 0, "Sorry this Music Stand is Out of funds, owner needs to pay more L$ into it");
        return;
    }
    if (count == 0){
        findRegister(llGetOwner(), CHECK_BEFORE_CONDUCT);
    }else{
        key id = llDetectedKey(0);
        llRegionSayTo(id, 0, "Your Baton is in use, please wait a moment...");
    }
    // if (llDetectedKey(0) != llGetOwner()) return;
    if (count != 0) 
        llOwnerSay("Your Baton is in use, please wait a moment...");
        
    else if (llGetAttached() != 0)
        llRegionSay(BATON_REPLY_CHANNEL,"findstand"+","+(string)llGetOwner());
}
key currentParcel() { return llList2Key(llGetParcelDetails(llGetPos(), [PARCEL_DETAILS_ID]), 0); }
   
integer usageBatonType;
integer usageStart;
integer usageNbTimes;

integer DAY = 86400;
   
default
{
    state_entry()
    {
        init();
    }
    
    // on_rez( integer start_param ){ ; }
    // Triggered when an object is rezzed (by script or by user). Also triggered in attachments when a user logs in, or when the object is attached from inventory.
    on_rez(integer param)
    {
        if (llGetAttached() == 0) 
            llOwnerSay("/me must be worn and not rezzed in world. Please take it back in your inventory and wear.");
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
                llOwnerSay("You are a new user, registration in progress...");    
                createRegister(llGetOwner());
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
                        boosterCounterM = llList2Integer(l, 2);                        
                    }
                }
                
                if (findingRegisterReason == INITIAL)
                {
                    llOwnerSay("Your stats are " + stats + " / Boosters: Apprentice:" + (string) boosterCounterA + " - " + "Professional:" + (string) boosterCounterP + " - " + "Maestro:" + (string) boosterCounterM);  
                    INITIAL = INITIAL + 1;
                }
                else
                {
                    checkForUsage();
                }                
                                
                noText();

            }
        }
        
        if (createRegisterReq == request_id)
        {
            list resp = llParseString2List(body, ["\n"], []);
            string ans = llList2String(resp, 0);
            
            if ("CREATED" == ans)
            {
                llOwnerSay("You just registered. We wish you a great experience !!!");
                
                findRegister(llGetOwner(), INITIAL);   
            }    
        }
        
        if (updateRegisterPropertiesReq = request_id)
        {
            list resp = llParseString2List(body, ["\n"], []);
            string ans = llList2String(resp, 0);
            
            if ("UPDATED" == ans)
            {
                noText();
            }
        }
        
        if (findUsageReq == request_id)
        {
            list resp = llParseString2List(body, ["\n"], []);
            string ans = llList2String(resp, 0);

            if ("NOT FOUND" == ans)
            {
                llOwnerSay("New location to conduct in !!!! Registration in progress...");    
                createUsage(llGetOwner(), currentParcel(), batonType, llGetUnixTime(), 1);
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
                    if (k == "baton_type") usageBatonType = (integer) v;
                    if (k == "start") usageStart = (integer) v;
                    if (k == "nb_times") usageNbTimes = (integer) v;
                }
                
                if (usageBatonType != batonType)
                {
                    if (llGetUnixTime() - usageStart > DAY)
                    {
                        usageNbTimes = 1;
                        usageStart = llGetUnixTime();
                        
                        debug("Update usage in type");    
                        updateUsage(llGetOwner(), currentParcel(), usageBatonType, usageStart, usageNbTimes);
                    }
                    else
                    {
                        debug("Not same baton type");
                        startIfAllowed(FALSE, usageStart, "BATON");    
                    }
                }
                else
                {
                    if (usageNbTimes+1 < maxNbTimes)    
                    {
                        if (llGetUnixTime() - usageStart > DAY)
                        {
                            usageNbTimes = 1;
                            usageStart = llGetUnixTime();
                        }
                        else 
                            usageNbTimes += 1;    
                            
                        debug("Update usage in nbtimes");    
                        updateUsage(llGetOwner(), currentParcel(), usageBatonType, usageStart, usageNbTimes);
                    }
                    else
                    {
                        if (llGetUnixTime() - usageStart > DAY)
                        {
                            usageNbTimes = 1;
                            usageStart = llGetUnixTime();
                            
                            debug("Update usage in type");    
                            updateUsage(llGetOwner(), currentParcel(), usageBatonType, usageStart, usageNbTimes);
                        }
                        else
                        {
                            debug("Max Nb Times reached");
                            llOwnerSay("Max Nb Times reached");    
                            startIfAllowed(FALSE, usageStart, "NBTIMES");    
                        }
                    }
                }
            }
        }
        
        if (updateUsageReq == request_id)
        {
            list resp = llParseString2List(body, ["\n"], []);
            string ans = llList2String(resp, 0);
            
            if ("UPDATED" == ans)
            {
                startIfAllowed(TRUE, llGetUnixTime(), "");               
            }
        }
        
        if (createUsageReq == request_id)
        {
            list resp = llParseString2List(body, ["\n"], []);
            string ans = llList2String(resp, 0);
            
            if ("CREATED" == ans)
            {
                startIfAllowed(TRUE, llGetUnixTime(), "");               
            }
        }
    }
    
    touch_start(integer total_number)
    {
     baton_touched(0);   
    }
    
    attach(key id)
    {
        if (id) llResetScript();
    }
    
    listen(integer ch, string name, key id, string message)
    {   
        if (SCRIPT_DEBUG_CHANNEL == ch) manageDebug(message);         
        
        if (ch == MENU_CHANNEL)
        {
            if (ANIMS == currentMenu)
            {
                llListenRemove(animMenuId);

                animToPlay = message;
                
                if (batonType != M) start(message, countValueToApply);
                else
                {
                    list ebcMenu = ["None"];
                    if (boosterCounterA != 0) ebcMenu += ["Apprentice"];
                    if (boosterCounterP != 0) ebcMenu += ["Professional"];
                    if (boosterCounterM != 0) ebcMenu += ["Maestro"];
                    
                    if (llGetListLength(ebcMenu) != 1)
                        showEBCMenu(ebcMenu);
                    else
                        start(message, countValueToApply);
                }
                            
                return; 
            }   
            
            if (EBC == currentMenu)
            {
                llListenRemove(ebcMenuId);
                
                ebcToUse = message;
                start(animToPlay, countValueToApply);
            }
        }
       
        if (ch == HUD_CHANNEL)
        {
            list temp = llCSV2List(message);
            
            if (llList2String(temp,0) == "conduct" && llList2String(temp,1) == (string)llGetOwner())
            {
                baton_touched(1);
                if(count != 0) llOwnerSay("Your Baton is in use, please wait a moment...");
                else llRegionSay(BATON_REPLY_CHANNEL,"findstand"+","+(string)llGetOwner());
            }
        
        }
        
        if (ch == BATON_CHANNEL)
        {
            debug("BATON CHANNEL : " + message);
            
            list temp = llCSV2List(message);
            string cmd = llList2String(temp,0);
            if ("showtext" == cmd)
            {
                llSetText("",<0,1,0>,1);
            }
            else if (llList2String(temp,1) == llGetOwner())
            {
                if ("outofdist" == cmd){
                     llOwnerSay("Sorry you are too far from any Music Stand – please move closer to the Music Stand");
                     
                }else  if ("outoffund" == cmd  && count == 0  && standId == NULL_KEY){
                     llOwnerSay("Music stand is out of fund...");
                     debug("Music stand is out of fund...");    

                }else if ("searchb" == cmd)
                {
                    standId = id;
                    debug("Wearing Maestros Baton");
                    // findRegister(llGetOwner(), CHECK_BEFORE_CONDUCT);
                }
                else if ("timestart" == cmd && standId == id)
                {
                    totalplay++;
                    timeinterval = llList2Integer(temp,2);
                    boosterflag = 0;
                    count = timeinterval;
                    
                    if (batonType == M){
                        llOwnerSay("You have clicked your Baton, please wait and see what your rewards will be...");
                        start("Jazz conductor", count);
                    } 
                    else showAnimationMenu(count);                                        
                }
            }
        }
    }
       
    timer()
    {
        if (count > 0)
        {
            count--;
            if (currentBooster == M)
                llSetText((string)count+" Seconds......",<255,0,102>,1);
            else if (currentBooster == P)
                llSetText((string)count+" Seconds......",<0,0,1>,1);
            else if (currentBooster == APPRENTICE)
                llSetText((string)count+" Seconds......",<1.000, 0.522, 0.106>,1);
             else
                llSetText((string)count+" Seconds......",<1,1,1>,1);
        }
        else if (count ==  0)
        {
            llStopSound();
            llPlaySound("Fanfare",1);
            llStopAnimation(currentAnim);
            llMessageLinked(LINK_THIS,4444444,(string)standId+","+"1,"+(string)timestarted,""); 
            llRegionSayTo(standId,BATON_REPLY_CHANNEL,"FinishedCounter"+","+(string)llGetOwner()+","+(string) XPImprovment);
            llMessageLinked(LINK_THIS,23729,"stop",""); 
            updateProperties();
            stop();
        }
        else
        {
            stop();
        }
    }
}
