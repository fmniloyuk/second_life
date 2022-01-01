// http://maestrosmusicsymbols.net/rules/
// http://maestrosmusicsymbols.net/maestros-music-symbols-lands/

integer HUD_CHANNEL = 2021091821;

string url = "http://165.22.114.113/";

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
        // string llGetLinkName( integer link );
        // Returns a string that is the name of link in link set
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


    //Triggered when task receives a response to one of its llHTTPRequests
    http_response(key request_id, integer status, list metadata, string body)
    {
        llOwnerSay(body);
        
        if (request_id == balancekey)
        {           
           // list llCSV2List( string src );
           // This function takes a string of values separated by commas, and turns it into a list. 
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
           // list llCSV2List( string src );
           // This function takes a string of values separated by commas, and turns it into a list.
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
