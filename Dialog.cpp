// When the prim is touched, give the toucher the option of killing the prim.
 
integer gListener;     // Identity of the listener associated with the dialog, so we can clean up when not needed
key who = NULL_KEY;

default
{
    touch_start(integer total_number)
    {
        who = llDetectedKey(0);
        // Kill off any outstanding listener, to avoid any chance of multiple listeners being active
        llListenRemove(gListener);
        // get the UUID of the person touching this prim
        key user = llDetectedKey(0);
        // Listen to any reply from that user only, and only on the same channel to be used by llDialog
        // It's best to set up the listener before issuing the dialog
        gListener = llListen(-99, "", user, "");
        // Send a dialog to that person. We'll use a fixed negative channel number for simplicity
        llDialog(user, "\nSelect an option from below?", ["Deposit", "Auto refill", "Concert", "Stats", "Rename", "Contact", "Support", "Ignore"] , -99);
        // Start a one-minute timer, after which we will stop listening for responses
        llSetTimerEvent(60.0);
    }
    listen(integer chan, string name, key id, string msg)
    {
        // If the user clicked the "Yes" button, kill this prim.
        if (msg == "Deposit"){
            llRegionSayTo(who, 0,"Selected "+msg);    
        }
        if (msg == "Auto refill"){
            llRegionSayTo(who, 0,"Selected "+msg);    
        }
        if (msg == "Concert"){
            llRegionSayTo(who, 0,"Selected "+msg);    
        }
        if (msg == "Stats"){
            llRegionSayTo(who, 0,"Selected "+msg);    
        }
        if (msg == "Rename"){
            llRegionSayTo(who, 0,"Selected "+msg);    
        }
        if (msg == "Contact"){
            llRegionSayTo(who, 0,"Selected "+msg);    
        }
        if (msg == "Support"){
            llRegionSayTo(who, 0,"Selected "+msg);    
        }
        if (msg == "Ignore"){
            llRegionSayTo(who, 0,"Selected "+msg);    
        }
            //llDie();
        // The user did not click "Yes" ...
        // Make the timer fire immediately, to do clean-up actions
        llSetTimerEvent(0.1);        
    }
    timer()
    {
        // Stop listening. It's wise to do this to reduce lag
        llListenRemove(gListener);
        // Stop the timer now that its job is done
        llSetTimerEvent(0.0);// you can use 0 as well to save memory
    }
}