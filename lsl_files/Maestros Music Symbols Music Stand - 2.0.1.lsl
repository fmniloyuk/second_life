
string url = "http://165.22.114.113/";

integer debugIsOn = TRUE; integer SCRIPT_DEBUG_CHANNEL = -20210000; listenDebug() { llListen(SCRIPT_DEBUG_CHANNEL, "", NULL_KEY, ""); llSay(SCRIPT_DEBUG_CHANNEL, "??");} manageDebug(string cmd) { if (cmd != "??") debugIsOn = (cmd == "DEBUG_ON"); llWhisper(0, "DEBUG [" + llList2String(["OFF", "ON"], debugIsOn) + "]"); } debug(string s) { if (debugIsOn) llSay(0, "--------------- DEBUG:" + s); }

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
    //debug(req);
    return llHTTPRequest(req, [], "");
}

string getSurl() { vector pos = llGetPos(); return "http://slurl.com/secondlife/" + llGetRegionName() + "/" + (string) llRound(pos.x) + "/" + (string)llRound(pos.y) + "/"+(string)llRound(pos.z); }

actionText(string s)
{
    llSetText(s, <1,1,0>, 1);        
}

key findStandReq;
findStand(key ownerKey, key standKey)
{
    actionText("Searching for this stand...");
    debug("findStand");
    findStandReq = doHttpRequest("stand_CRU.php", ["action", "Read", "owner_key", ownerKey, "stand_key", standKey]);
}

key createStandReq;
key owner_key;
key stand_key;

createStand(key ownerKey, key standKey)
{
    owner_key = ownerKey;
    stand_key = standKey;
    actionText("Registering this stand...");
    debug("createStand");
    createStandReq = doHttpRequest("stand_CRU.php", 
        ["action", "Create", "owner_key", ownerKey, "stand_key", standKey, "owner_name", llKey2Name(llGetOwner()),
         "money", 0, "surl", getSurl(), "nb_votes", 0]);
}

key standKey;
key updateMoneyAndSurl;
updateStandMoneyAndSurl()
{
    debug("updateStandMoneyAndSurl");
    actionText("Updating this stand...");
    updateMoneyAndSurl = doHttpRequest("stand_CRU.php", 
        ["action", "UpdateMoneyAndSurl", "owner_key", llGetOwner(), "stand_key", standKey, 
         "money", availableMoney, "surl", getSurl()]);
}

key addVoteReq;
addVoteForStand()
{
    debug("addVoteForStand");
    actionText("Adding vote for this stand...");
    addVoteReq = doHttpRequest("stand_CRU.php", 
        ["action", "UpdateNbVotes", "owner_key", llGetOwner(), "stand_key", standKey, "nb_votes", "+1"]);
}

integer BATON_CHANNEL       = 2021091801;
integer BATON_REPLY_CHANNEL = 2021091808;

integer VOTE_TO_STAND_CHANNEL = 202110011;
integer STAND_TO_VOTE_CHANNEL = 202110012;

//integer amount = 0;
integer CHANNEL = 0;
integer RENAME_CHANNEL = 0; 
float availableMoney = 0;
integer messageflag = 0;
key mowner = "e53a44de-09d6-438c-949e-ecf79104fee3";
key taxowner = "ccb679d9-690e-4b6c-a7eb-769712f1d0aa";

key moneyreq;
key givemoney;
string knowledge;
integer isBusy = FALSE;
key player = NULL_KEY;
 
integer timeinterval = 176; 
list tempplayers;

integer minimumamount = 1;

list sharps = [0.005,0.005,0.020,0.040,1,1.09];
list sharpsexp = [1,2,3,4,5,6];
list sharpsname = ["C Major (No sharps or flats)","G Major (F#)","D Major (F#, C#) ","A Major (F#, C#, G#)","E Major (F#, C#, G#, D#)","B Major (F#, C#, G#, D#, A#)"];


list flats = [0.010,0.020,0.030,0.060,0.089,1];
list flatsexp = [1,2,3,4,5,6];
list flatsname = ["F Major (B♭)","B♭ Major (B♭,E♭)","E♭ Major (B♭,E♭,A♭)","A♭ Major (B♭,E♭,A♭,D♭)","D♭ Major (B♭,E♭,A♭,D♭,G♭)","G♭ Major (B♭,E♭,A♭,D♭,G♭,C♭)"];


list notes = [0.010,0.020,0.030,0.040,0.050,0.089,2];
list notesexp = [1,2,3,4,5,6,7];
list notesname = ["Whole Note (4 counts)", "Half Note (2 counts)", "Quarter Note (1 count)","Eighth Note (quaver)","Sixteenth Note (semiquaver)","Dotted Half Note (3 counts)","Dotted Quarter Note (1½ counts)"];


list majorchords = [0.01,0.02,0.20,0.04,0.20,0.10];
list majorchordsexp = [1,2,3,4,5,6];
list majorchordsname =["C Major – (C E G)","G Major – (G B D)","D Major - (D F# A)","E Major – (E G# B)","A Major -  (A C# E)", "B Major – (B D# F#)"];

list rests = [0.07,1,0.09,0.10,2,2];
list restsexp = [1,2,3,4,5,6];
list restsname =["Whole Note Rest","Half Note Rest","Quarter Note Rest","Eighth Note Rest", "1/16th Note Rest","1/32nd Note Rest"];


list performancedirections = [0.01,0.02,1,0.04,1,0.06,0.07];
list performancedirectionsexp = [1,2,3,4,5,6,7];
list performancename =["Treble Clef (Right Hand)","Bass Clef (Left Hand)","Piano - soft (P)","Mezzo Piano - Moderately Soft (MP)","Forte - Loud (F) ","Mezzo Forte - Moderately Loud (MF)","Fine (The End)"];

integer onlyreward = 38;

integer clickcount = 0;

key memberkey;
integer permissions = FALSE;
integer Multiplier = 1;
string booster;
integer autorefill = 0;
list users = [];
key previousuuid = NULL_KEY;
key presentuuid = NULL_KEY;
key rezkey;
string standname;
hover()
{
    llSetText(standname+" \n Level One \n x"+
        (string)Multiplier+" payout \n"
        +" and \n Music Stand has "+(string)llFloor(availableMoney)+" L$",<1,1,1>,1);    
}

init()
{  
    isBusy = FALSE;
    CHANNEL = llFloor(llFrand(7483)+4837);
    llListen(CHANNEL,"", NULL_KEY,"");
    
    RENAME_CHANNEL = llFloor(llFrand(7483)+3342);
    llListen(RENAME_CHANNEL,"",NULL_KEY,"");
        
    llSetTimerEvent(5);
    llSetText("",<1,0,0>,1);
    standname = llGetObjectName();
    hover();
         
    llSetPayPrice(200, [200 ,500, 1000, 2000]);
    //showOptionsMenu();
}

showOptionsMenu()
{
    llDialog(llGetOwner(),"Please select any options from the given list",
        ["Stats","Rename","Support","Deposit","Auto refill","Concert"], CHANNEL);    
}

integer isKey(key in) { if (in) return TRUE; return (in == NULL_KEY); }
 
requestPermissions()   
{
    actionText("Please allow DEBIT premissions.");
    llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);    
}

key updateXpAndMoneyReq;
updateXpAndMoney(key avatarKey, integer xp, float gainedMoney)
{
    debug("updateXpAndMoney");
    updateXpAndMoneyReq = doHttpRequest("register_CRU.php", 
        ["action", "UpdateXpAndMoney", 
        "avatar_key", avatarKey, 
        "amount", "+" + (string) gainedMoney, 
        "experience", "+" + (string) xp, 
        "total_amount", "+" + (string) gainedMoney]);
}

default
{
    on_rez(integer p) { llResetScript(); }
    
    state_entry() 
    {
        availableMoney = 0;
        isBusy = TRUE;
        
        llListen(BATON_REPLY_CHANNEL,"", NULL_KEY,"");
        llListen(VOTE_TO_STAND_CHANNEL,"", NULL_KEY,""); 
        listenDebug();       
        
        standKey = (key) llGetObjectDesc();
        
        requestPermissions();
    }

    touch_start(integer availableMoney_number)
    {
        createStandReq = doHttpRequest("stand_CRU.php", 
        ["action", "Create", "owner_key", owner_key, "stand_key", stand_key, "owner_name", llKey2Name(llGetOwner()),
         "money", 0, "surl", getSurl(), "nb_votes", 0]);
        if (llDetectedKey(0) == llGetOwner())
        {
            if (!permissions) requestPermissions();
            else
            {
                llSetPayPrice(200, [200 ,500, 1000, 2000]);
                showOptionsMenu();
            }
        }
       else
       {           
            if (availableMoney < 1)
            {
                llRegionSayTo(llDetectedKey(0),0,"Sorry this Music Stand is Out of funds, owner needs to pay more L$ into it");
                 llSleep(1);
            }
            else
            {
           
                if (isBusy)
                {
                    llRegionSayTo(llDetectedKey(0),0,"This Music Stand is busy.. try after some time...");
                    llSleep(1);
                }
                else{
                   /* llSetTimerEvent(5);
                    player = llDetectedKey(0);
                    busy = 1;
                    llRegionSay(BATON_CHANNEL,"searchb"+","+(string)llDetectedKey(0));*/
                }
            }
      }
    }
    
    timer()
    {
        if (isBusy)
        {
            isBusy = FALSE;
            player = NULL_KEY;             
        }
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_DEBIT)
        {                
            if (isKey(standKey)) 
                findStand(llGetOwner(), standKey);
            else 
            {
                standKey = llGetKey();
                llSetObjectDesc(standKey);
                
                createStand(llGetOwner(), standKey);
            }
                                                                                   
            permissions = TRUE;
           
        }
        else 
        {
            llOwnerSay("You must accept DEBIT permissions to have the stand working. Please touch it and 'Allow access'.");
            permissions = FALSE;
        }
    }
    
    money(key id, integer amount)
    {
        float percent = amount/10;
        
        if (percent == 0) percent = 1;
        
        float stand_money = amount - percent;
        
        availableMoney += stand_money;
        
        messageflag = 0; 
        
        if ((string) llGetOwner() == "59992c57-4d1e-4f43-a0c4-6dc8ec37d665")
        {
            debug("DEBUG : Money not sent");    
        }
        else
        {        
            llGiveMoney(taxowner,(integer)percent);
            llGiveMoney(mowner,(integer)(amount-percent));
        }
        
        llOwnerSay("Money of L$ "+(string)stand_money+" is sent to music stand and,  L$"+(string)percent+" is deducted as tax and available money amount in music stand is L$"+(string)availableMoney);
                        
        updateStandMoneyAndSurl();
    } 
    
    listen(integer channel, string name, key id, string message)
    {
        debug("Listen: " + (string) channel + " " + message);
        
        if (SCRIPT_DEBUG_CHANNEL == channel) manageDebug(message);
        
        if (VOTE_TO_STAND_CHANNEL == channel)
        {
            list l = llParseString2List(message, ["¥"], []);
            string cmd = llList2String(l, 0);
            
            if ("CheckSameOwnerAndParcel" == cmd)
            {
                if (llList2Key(l, 1) != llGetOwner()) return;
                if (llList2Key(l, 2) != llList2String(llGetParcelDetails(
                                              llGetPos(), 
                                              [PARCEL_DETAILS_ID]), 0)) return;
                                              
                llRegionSayTo(id, STAND_TO_VOTE_CHANNEL, "MaestroStand¥" + (string)availableMoney);
            }
            
            if ("OneMoreVote" == cmd)
            {
                addVoteForStand();    
            }
            
            return;    
        }
        
        if(channel == CHANNEL){
            //llOwnerSay("message"+message);
            if(message == "Deposit"){
                llOwnerSay("Right click and pay to proceed....");
                llSetPayPrice(200, [200 ,500, 1000, 2000]);
            }
            else  if(message == "Auto refill"){
                if(autorefill == 0)
                    llDialog(llGetOwner(),"Please select Auto refill from the below option..",["On"],CHANNEL);
                else  if(autorefill ==1)
                    llDialog(llGetOwner(),"Please select Auto refill from the below option..",["Off"],CHANNEL);
            }
            else if(message == "On"){
                autorefill = 1;
                llOwnerSay("auto refill is set to On...");
            }
            else if(message == "Off"){
                autorefill = 0;
                llOwnerSay("auto refill is set to Off...");
            }
            else if(message == "Stats"){
                 if( llGetListLength(users) == 0)
                    llOwnerSay("Sorry... No users Found..");
                 else{
                     integer i = 0;
                       llOwnerSay("Music Stand is used by the following users...");
                     for(i = 0; i < llGetListLength(users); i= i+2){
                          llOwnerSay(llList2String(users,i)+", Time : "+llList2String(users,i+1));
                     }
                 }
            }
            else if(message == "Support"){
                llOwnerSay("Support");
            }
            else if(message == "Concert"){
                    llDialog(llGetOwner(),"Please select a Concert Event from the below options..",["x9","x9", "x10", "x5", "x6", "x7", "x2", "x3", "x4", "x1"],CHANNEL);
            }  
            else if(message == "x1"){
                Multiplier = 1;
                llOwnerSay("Concert Event is set to x1 payout");
                llSetText("x1 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                hover();
            
            }
            else if(message == "x2"){
                Multiplier = 2;
                llOwnerSay("Concert Event is set to x2 payout");
                llSetText("x2 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                hover();
            }
            else if(message == "x3"){
                Multiplier = 3;  
                llOwnerSay("Concert Event is set to x3 payout");
                 llSetText("x3 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                 hover();
            }
            else if(message == "x4"){
                Multiplier = 4;
                llOwnerSay("Concert Event is set to x4 payout");
                llSetText("x4 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                 hover();
            }
            else if(message == "x5"){
                Multiplier = 5;
                llSetText("x5 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                llOwnerSay("Concert Event is set to x5 payout");
                 hover();
            
            }
            else if(message == "x6"){
                Multiplier = 6;  
                llSetText("x6 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                 llOwnerSay("Concert Event is set to x6 payout");
                 hover();
            }
            else if(message == "x7"){
                Multiplier = 7;
             llSetText("x7 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                 llOwnerSay("Concert Event is set to x7 payout");
                 hover();
            }
            else if(message == "x8"){
                Multiplier = 8;
             llSetText("x8 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                 llOwnerSay("Concert Event is set to x8 payout");
                 hover();
            }
            else if(message == "x9"){
                Multiplier = 9;
                llSetText("x9 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                llOwnerSay("Concert Event is set to x9 payout");
                 hover();
            }
            else if(message == "x10"){
                Multiplier = 10;
                llSetText("x10 payout"+" and \n Music Stand has "+(string)availableMoney+" L$",<1,1,1>,1);
                llOwnerSay("Concert Event is set to x10 payout");
                 hover();
            }
            else if(message == "Rename"){
                llTextBox(llGetOwner(),"Please type the New name for the music stand", RENAME_CHANNEL);
            }
            else if(message == "Custom Amount"){
                llTextBox(llGetOwner(),"Please put price in terms of L$",CHANNEL);
            }
            else if((integer)message > 0){
                availableMoney += (integer)message;
                debug("Available Money: "+ (string)availableMoney);
                llGiveMoney(mowner,(integer)message);
                 moneyreq = llHTTPRequest(url+"stand.php?money="+(string)availableMoney+"&sender="+(string)llEscapeURL(llGetOwner())+"&sendername="+(string)llEscapeURL(llKey2Name(llGetOwner()))+"&region="+(string)llEscapeURL(llGetRegionName())+"&present="+(string)presentuuid+"&previous="+(string)previousuuid, [], "");
                hover();
                llOwnerSay("Money of L$ "+message+" is sent to music stand");
            }
            else if((integer)message ==  0){
               llOwnerSay("Invalid amount sent... Please try with valid amount..");
            }
        }
        else if (channel == RENAME_CHANNEL)
        { 
            if(message == "")
                llOwnerSay("You can't set empty name for the Music Stand");
            else{
                llSetObjectName(message);
                standname = message;
                llOwnerSay("New name "+message+" is set successfully...");
                hover();
            }
        } 
        else if (BATON_REPLY_CHANNEL == channel)
        {
            list temp = llCSV2List(message);
            string cmd = llList2String(temp,0);
            
            if ("findstand" == cmd)
            {
                key batonPlayer = llList2String(temp,1);
                
                if (availableMoney < 1)
                    llRegionSayTo(batonPlayer, 0, "Sorry this Music Stand is Out of funds, owner needs to pay more L$ into it");
                else
                {
                    if (isBusy)
                    {
                        llRegionSayTo(batonPlayer,0,"This Music Stand is busy.. try after some time...");
                    }
                    else
                    {
                        llSetTimerEvent(5);
                        player = batonPlayer;
                        isBusy = TRUE;
                        llRegionSay(BATON_CHANNEL,"searchb"+","+(string)batonPlayer);
                    }
                }
                    
            }
            else if (llList2String(temp,0)  == "ihave" && availableMoney < minimumamount)
            {
                llRegionSayTo(id,BATON_CHANNEL,"outoffund"+","+(string)llList2String(temp,1));
                if(autorefill == 1)
                    llInstantMessage(llGetOwner(),"This Music Stand is out of funds, please right click Stand to pay in order to proceed.");
            }
            else if (llList2String(temp,0)  == "ihave" && availableMoney >= minimumamount)
            {
                 vector mypos = llGetPos();
                 list pos = llGetObjectDetails(id,[OBJECT_POS]);
                 if (llVecDist(mypos,(vector)llList2String(pos,0)) > 30)
                 {
                      llRegionSayTo(id,BATON_CHANNEL,"outofdist"+","+(string)player);
                 }
                 else
                 {
                     player = llList2String(temp,1);
                     booster = llList2String(temp,2);
                     if (booster == "1")
                     {
                        llRegionSayTo(id,BATON_CHANNEL,"timestart"+","+(string)player+","+(string)(timeinterval/2));
                        debug("timestart"+","+(string)player+","+(string)(timeinterval/2));
                     }
                     else
                     {
                        llRegionSayTo(id,BATON_CHANNEL,"timestart"+","+(string)player+","+(string)timeinterval);
                     }
                     tempplayers += [(string)player,llGetUnixTime()];
                     users += [llKey2Name(player),llGetTimestamp()];
                     isBusy = FALSE;
                     llSetTimerEvent(0);
                     player = NULL_KEY;
                     if (llGetListLength(users) > 40)
                     {
                         integer availableMoneylength = llGetListLength(users);
                         users = llDeleteSubList(users,0,availableMoneylength-40);
                     }
                }
            }
            else if(llList2String(temp,0)  == "maxreached"){
                isBusy = FALSE;
                llSetTimerEvent(0);
                player = NULL_KEY;
            }
            else if (llList2String(temp,0)  == "FinishedCounter")
            {
                clickcount++;
                string knowldge;
                integer index = llListFindList(tempplayers,[llList2String(temp,1)]);
                integer XPImprovment = llList2Integer(temp, 2); // From baton's type
                debug("XPImp ? : " + llList2String(temp, 2));
                debug("XPImp integer: " + (string) XPImprovment);
                integer randtype = llFloor(llFrand(6));
                list templist = [];
                list tempexp = [];
                float reward = 0;
                integer experience;
                if(clickcount > 13 && clickcount < 15 &&  llFloor(llFrand(2)) == 0){
                }
                else if(clickcount > 30 &&  llFloor(llFrand(2)) == 0){
                 clickcount = 0; 
                }
                
                integer randtypesel; 
                
                 if(randtype == 0) // notes 
                 { 
                    templist = llList2List(notes,0,-1);
                    tempexp =  llList2List(notesexp,0,-1);
                    randtypesel = llFloor(llFrand(llGetListLength(templist)));
                    reward = llList2Float(templist,randtypesel)*Multiplier;
                    experience = llList2Integer(tempexp,randtypesel);
                    knowldge = llList2String(notesname,randtypesel);
                 }
                 else if(randtype ==  1){ // Sharps 
                 
                    templist = llList2List(sharps,0,-1);
                    tempexp =  llList2List(sharpsexp,0,-1);
                    randtypesel = llFloor(llFrand(llGetListLength(templist)));
                    reward = llList2Float(templist,randtypesel)*Multiplier;
                    experience = llList2Integer(tempexp,randtypesel);
                    knowldge = llList2String(sharpsname,randtypesel);
                 }
                 else if(randtype == 2){ // flats 
                
                    templist = llList2List(flats,0,-1);
                    tempexp = llList2List(flatsexp,0,-1);
                    randtypesel = llFloor(llFrand(llGetListLength(templist)));
                    reward = llList2Float(templist,randtypesel)*Multiplier;
                    experience = llList2Integer(tempexp,randtypesel);
                    knowldge = llList2String(flatsname,randtypesel);
                }
                else if(randtype == 3){ // majorchord
                
                    templist = llList2List(majorchords,0,-1);
                    tempexp = llList2List(majorchordsexp,0,-1);
                    randtypesel = llFloor(llFrand(llGetListLength(templist)));
                    reward = llList2Float(templist,randtypesel)*Multiplier;
                    experience = llList2Integer(tempexp,randtypesel);
                    knowldge = llList2String(majorchordsname,randtypesel);
                 }
                 else if(randtype == 4){ // rests                   
                    templist = llList2List(rests,0,-1);
                    tempexp = llList2List(restsexp,0,-1);
                    randtypesel = llFloor(llFrand(llGetListLength(templist)));
                    reward = llList2Float(templist,randtypesel)*Multiplier;
                    experience = llList2Integer(tempexp,randtypesel);
                    knowldge = llList2String(restsname,randtypesel);
                }
                else if(randtype == 5){
                   
                    templist = llList2List(performancedirections,0,-1);
                    tempexp = llList2List(performancedirectionsexp,0,-1);
                    randtypesel = llFloor(llFrand(llGetListLength(templist)));
                    reward = llList2Float(templist,randtypesel)*Multiplier;
                    experience = llList2Integer(tempexp,randtypesel);
                    knowldge = llList2String(performancename,randtypesel);
                }
                
                availableMoney = availableMoney - reward;
                memberkey = (key)llList2String(temp,1);
                
                debug("Experience Before: " + (string) experience);
                experience += XPImprovment; // From baton's type
                debug("Experience After: " + (string) experience);
                
                updateXpAndMoney(memberkey, experience, reward);
            
                llRegionSayTo(memberkey, 0, "You just got music knowledge '"+knowldge+"'  with reward of "+(string)reward+" L$ and "+(string)experience+" XP. Your account was updated.");

                hover();
                
                tempplayers = llDeleteSubList(tempplayers,index, index+1);
                
                updateStandMoneyAndSurl();
            } 
        } 
    }
    
    http_response(key request_id, integer status, list metadata, string body)
    {
        debug("HTTP Response: "+ (string) status + " " + body);
        
        if (findStandReq == request_id)
        {
            list resp = llParseString2List(body, ["\n"], []);
            string ans = llList2String(resp, 0);
            
            if ("NOT FOUND" == ans)
            {
                llOwnerSay("Stand not registered in our system.");                    
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
                    
                    if (k == "money") availableMoney = (float) v;
                }
                
                if (!permissions) requestPermissions();                
                else init();
            }
        }
        
        if (createStandReq == request_id)
        {
            llOwnerSay("This stand has been registered.");
            init();
        }
        
        if (updateMoneyAndSurl == request_id)
        {
            llOwnerSay("This stand money has been updated.");
            hover();
        }
        
        if (addVoteReq == request_id)
        {
            llOwnerSay("One more vote has been done : " + getSurl());
            hover();
        }
    
        if (request_id == moneyreq)
        {
           llOwnerSay(body);
        }
        else  if (request_id == rezkey)
        {
           llOwnerSay(body);
        }
        else if(request_id == givemoney)
        {
            list temp = llParseString2List(body,[","], []);
            if(llList2String(temp,0) == "successfull"){
                llRegionSayTo(memberkey,0,"Your availableMoney reward is L$ "+llList2String(temp,1)+" and availableMoney experience is "+llList2String(temp,2));
            }
            else{
                llOwnerSay(body);
            }
        }
    }           
}
