/*
Senua's Saga: Hellblade II Autosplitter + Load Remover
Made by CactusDuper (@CactusDuper on Discord)

https://www.speedrun.com/Hellblade2

Last updated: 24 May 2024
*/

state("Hellblade2-Win64-Shipping", "1.0.0.0 Steam")
{
	
}

state("Hellblade2-WinGDK-Shipping", "1.0.0.0 Xbox")
{

}


startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");

	settings.Add("test_cine", false, "Alternative cinematic LRT");

	settings.Add("ch1", true, "First Chapter");
	settings.Add("0_1_8", false, "Landfall", "ch1");
	settings.Add("0_2_13", false, "Shore of Slaves", "ch1");
	settings.Add("0_3_15", false, "Capsized Ship", "ch1");
	settings.Add("1_0_0", true, "Slavemaster Found (Ch1 end)", "ch1");
	
	settings.Add("ch2", true, "Second Chapter");
	settings.Add("1_1_4", false, "Freyslaug Sighted", "ch2");
	settings.Add("1_2_8", false, "Settlement Entrance", "ch2");
	settings.Add("1_3_16", false, "Return Home", "ch2");
	settings.Add("1_4_24", false, "Draugar Ceremony", "ch2");
	settings.Add("1_5_29", false, "Draugar Battle", "ch2");
	settings.Add("2_0_0", true, "Meeting the Stranger (Ch2 end)", "ch2");

	settings.Add("ch3", true, "Third Chapter");
	settings.Add("2_1_6", false, "Red Hills", "ch3");
	settings.Add("2_2_16", false, "Illtauga", "ch3");
	settings.Add("2_3_25", false, "On the Hill", "ch3");
	settings.Add("3_0_0", true, "Find the Hiddenfolk (Ch3 end)", "ch3");

	settings.Add("ch4", true, "Fourth Chapter");
	settings.Add("3_1_11", false, "Enter the Caves", "ch4");
	settings.Add("3_2_16", false, "Trial of Wisdom", "ch4");
	settings.Add("3_3_26", false, "Into Darkness", "ch4");
	settings.Add("3_4_41", false, "Act of Sacrifice", "ch4");
	settings.Add("3_5_47", false, "Breaking Through", "ch4");
	settings.Add("3_6_52", false, "A Gift Returned", "ch4");
	settings.Add("4_0_0", true, "The First Ritual (Ch4 end)", "ch4");

	settings.Add("ch5", true, "Fifth Chapter");
	settings.Add("4_1_2", false, "To the Sea", "ch5");
	settings.Add("4_2_12", false, "Sjavarrisi", "ch5");
	settings.Add("4_3_22", false, "Another Question", "ch5");
	settings.Add("4_4_29", false, "Astrior's Story", "ch5");
	settings.Add("4_5_33", false, "Waking the Giant", "ch5");
	settings.Add("5_0_0", true, "The Second Ritual (Ch5 end)", "ch5");

	settings.Add("ch6", true, "Sixth Chapter");
	settings.Add("5_1_14", false, "Into the Forest", "ch6");
	settings.Add("5_2_18", false, "Borgarvirki", "ch6");
	settings.Add("5_3_33", false, "Heart of Darkness", "ch6");
	settings.Add("5_3_36", true, "The Last Lie (Finish)", "ch6");
	//final one is 5_3_36 (no control after this point)


}

init
{
	vars.completedSplits = new HashSet<string>();

	//yoinked from the LoP splitter
	//Turn on to get memory size for latest patch. Will be used to identify version number. Don't forget to change the directory!
	//System.IO.File.WriteAllText(@"C:\Users\Cactus\modulesize.txt", "ModuleMemorySize: " + modules.First().ModuleMemorySize.ToString());
	//xbox: 164159488
	

	//yoinked from the LoP splitter
	vars.CheckSplit = (Func<string, bool>)(key =>
	{
		// if the split doesn't exist, or it's off, or we've done it already
        	if (!settings.ContainsKey(key) || !settings[key] || vars.completedSplits.Contains(key))
        	{
            		return false;
        	}
			vars.completedSplits.Add(key);
        	return true;
	});


	IntPtr gameEngine = vars.Helper.ScanRel(3, "48 8B 05 ?? ?? ?? ?? 48 8B 88 ?? ?? 00 00 48 85 C9 74 ?? 48 8B 49 ?? 48 85 C9");

	//vars.UI = new MemoryWatcher<IntPtr>(new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20));
	//vars.Char = new MemoryWatcher<IntPtr>(new DeepPointer(gameEngine, 0x10B8, 0x38, 0x0, 0x30, 0x328));

	vars.chapterIndex = new MemoryWatcher<int>(new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20, 0x410));
	vars.checkpointIndex = new MemoryWatcher<int>(new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20, 0x414));
	vars.devCheckpointIndex = new MemoryWatcher<int>(new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20, 0x418));
	vars.isLoading = new MemoryWatcher<bool>(new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20, 0x432));
	vars.isPaused = new MemoryWatcher<bool>(new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20, 0x439));
	vars.isMenuMusic = new MemoryWatcher<bool>(new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20, 0x43E));
	vars.activeChapterIndex = new MemoryWatcher<int>(new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20, 0x574));
	vars.IsSkipCinematicsAvailable = new MemoryWatcher<bool>(new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20, 0x444));

	vars.isInCinematicMode = new MemoryWatcher<bool>(new DeepPointer(gameEngine, 0x10B8, 0x38, 0x0, 0x30, 0x328, 0xFE8));


	//vars.UI = new DeepPointer(gameEngine, 0x10B8, 0xC0, 0X60, 0x20, 0x20).Deref<IntPtr>(game);
	//vars.Char = new DeepPointer(gameEngine, 0x10B8, 0x38, 0x0, 0x30, 0x328).Deref<IntPtr>(game);
}

onStart
{
	vars.completedSplits.Clear();
}

start
{
	if (vars.activeChapterIndex.Current == 0 && vars.checkpointIndex.Current == 0 && vars.devCheckpointIndex.Current == 1)
	{
        	return true;
	}
}

update
{	
	//vars.UI.Update(game);
	//vars.Char.Update(game);

	vars.chapterIndex.Update(game);
	vars.checkpointIndex.Update(game);
	vars.devCheckpointIndex.Update(game);
	vars.isLoading.Update(game);
	vars.isPaused.Update(game);
	vars.isMenuMusic.Update(game);
	vars.activeChapterIndex.Update(game);
	vars.IsSkipCinematicsAvailable.Update(game);
	vars.isInCinematicMode.Update(game);
	

	/*
	vars.chapterIndex = game.ReadValue<int>((IntPtr)vars.UI.Current + 0x410);
	vars.checkpointIndex = game.ReadValue<int>((IntPtr)vars.UI.Current + 0x414);
	vars.devCheckpointIndex = game.ReadValue<int>((IntPtr)vars.UI.Current + 0x418);
	vars.isLoading = game.ReadValue<bool>((IntPtr)vars.UI.Current + 0x432);
	vars.isPaused = game.ReadValue<bool>((IntPtr)vars.UI.Current + 0x439);
	vars.isMenuMusic = game.ReadValue<bool>((IntPtr)vars.UI.Current + 0x43E);
	vars.activeChapterIndex = game.ReadValue<int>((IntPtr)vars.UI.Current + 0x574);

	vars.IsSkipCinematicsAvailable = game.ReadValue<bool>((IntPtr)vars.UI.Current + 0x444);

	vars.isInCinematicMode = game.ReadValue<bool>((IntPtr)vars.Char.Current + 0xFE8);
	print(vars.isInCinematicMode.ToString());
	*/
}

split
{


	var key = vars.activeChapterIndex + "_" + vars.checkpointIndex + "_" + vars.devCheckpointIndex;

	if (vars.CheckSplit(key))
	{
		return true;
	}
	
}

isLoading
{
  	if (settings["test_cine"]){
		if(vars.isInCinematicMode.Current == true){
			return true;
		}
	}
    if (vars.isLoading.Current || vars.isPaused.Current || vars.isMenuMusic.Current || vars.IsSkipCinematicsAvailable.Current)
    {
        return true;
    }
    else
    {
        return false;
    }
}

reset
{
    if(vars.activeChapterIndex.Current == -1){
		return true;
	}
}

exit
{
}
