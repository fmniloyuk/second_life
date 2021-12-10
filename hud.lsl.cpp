//http://maestrosmusicsymbols.net/rules/
//[08:41] jbc71: http://maestrosmusicsymbols.net/maestros-music-symbols-lands/

integer HUD_CHANNEL = 2021091821;

string url = "http://maestrosmusicsymbols.net/api/";

key balancekey;
integer landmark = 0;
key landmarkkey;

default
{
    state_entry()
    {
       
    }

    touch_start(integer total_number)
    {
        string primName = llGetLinkName(llDetectedLinkNumber(0));
        
        if ("CONDUCT" == primName)
        {
            llRegionSay(HUD_CHANNEL, "conduct,"+(string)llGetOwner());
        }
        
        else if ("NEW" == primName)
        {
            //landmarkkey = llHTTPRequest(url+"hud.php?landmark="+(string)landmark, [], "");
            //llOwnerSay(url+"hud.php?landmark="+(string)landmark+"&membername="+(string)llEscapeURL(llKey2Name(llGetOwner())));
             llLoadURL(llGetOwner(),"Please load the url Just for testing..","http://maestrosmusicsymbols.net/maestros-music-symbols-lands/");
        }
       // llSay(0,(string)llDetectedLinkNumber(0));
        else if ("WIKIHELP" == primName)
        {
            llLoadURL(llGetOwner(),"Please load the url Just for testing..","http://maestrosmusicsymbols.net/rules/");
        }
        else if ("CASHOUT" == primName)
        {
            balancekey = llHTTPRequest(url+"hud.php?balance="+(string)llEscapeURL(llGetOwner())+"&membername="+(string)llEscapeURL(llKey2Name(llGetOwner())), [], "");
              // llOwnerSay(url+"hud.php?balance="+(string)llEscapeURL(llGetOwner())+"&membername="+(string)llEscapeURL(llKey2Name(llGetOwner())));
        }
        else
            llOwnerSay("Prim not managed : " + primName);
    }
    http_response(key request_id, integer status, list metadata, string body)
    {
        llOwnerSay(body);
        
        if (request_id == balancekey)
        {           
           list temp = llCSV2List(body);
           if(llList2String(temp,0) == "successfull"){
               llOwnerSay("your account balance is "+(string)llList2String(temp,1)+" L$");
        
           }
           else{
                llOwnerSay("Something went wrong.. please try after so time....");
            }
        }
        else if (request_id == landmarkkey)
        {
           list temp = llCSV2List(body);
           if(llList2String(temp,0) == "successfull"){
               landmark = (integer)llList2String(temp,2);
               llOwnerSay("you account balance is "+(string)llList2String(temp,1)+" L$");
        
           }
           else{
                llOwnerSay("Something went wrong.. please try after so time....");
            }
        }
    }
}
