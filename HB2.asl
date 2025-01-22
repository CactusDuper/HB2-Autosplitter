/*
Senua's Saga: Hellblade II Autosplitter + Load Remover
Made by CactusDuper (@CactusDuper on Discord)
Thank you for your help Salad :)

https://www.speedrun.com/Hellblade2

Last updated: 5 June 2024
*/

state("Hellblade2-Win64-Shipping", "Steam"){}

state("Hellblade2-WinGDK-Shipping", "Xbox"){}


startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");

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
	IntPtr gameEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");

	// GEngine->GameInstance->Unk_FByteProperty->PostConstructLinkNext->Outer->Outer->Focused_ChapterIndex
	vars.Helper["chapterIndex"] = vars.Helper.Make<int>(gameEngine, 0x10D0, 0xC0, 0x60, 0x20, 0x20, 0x418);

	// GEngine->GameInstance->Unk_FByteProperty->PostConstructLinkNext->Outer->Outer->Focused_CheckpointIndex
	vars.Helper["checkpointIndex"] = vars.Helper.Make<int>(gameEngine, 0x10D0, 0xC0, 0x60, 0x20, 0x20, 0x41C);

	// GEngine->GameInstance->Unk_FByteProperty->PostConstructLinkNext->Outer->Outer->Focused_DevCheckpointIndex
	vars.Helper["devCheckpointIndex"] = vars.Helper.Make<int>(gameEngine, 0x10D0, 0xC0, 0x60, 0x20, 0x20, 0x420);

	// GEngine->GameInstance->Unk_FByteProperty->PostConstructLinkNext->Outer->Outer->bIsLoading
	vars.Helper["isLoading"] = vars.Helper.Make<bool>(gameEngine, 0x10D0, 0xC0, 0x60, 0x20, 0x20, 0x43A);

	// GEngine->GameInstance->Unk_FByteProperty->PostConstructLinkNext->Outer->Outer->bIsGamePaused
	vars.Helper["isPaused"] = vars.Helper.Make<bool>(gameEngine, 0x10D0, 0xC0, 0x60, 0x20, 0x20, 0x441);

	// GEngine->GameInstance->Unk_FByteProperty->PostConstructLinkNext->Outer->Outer->bMenuMusic
	vars.Helper["isMenuMusic"] = vars.Helper.Make<bool>(gameEngine, 0x10D0, 0xC0, 0x60, 0x20, 0x20, 0x446);

	// GEngine->GameInstance->Unk_FByteProperty->PostConstructLinkNext->Outer->Outer->ActiveChapterIndex
	vars.Helper["activeChapterIndex"] = vars.Helper.Make<int>(gameEngine, 0x10D0, 0xC0, 0x60, 0x20, 0x20, 0x57C);

	// GEngine->GameInstance->Unk_FByteProperty->PostConstructLinkNext->Outer->Outer->IsSkipCinematicsAvailable
	vars.Helper["IsSkipCinematicsAvailable"] = vars.Helper.Make<bool>(gameEngine, 0x10D0, 0xC0, 0x60, 0x20, 0x20, 0x44C);
		
	vars.completedSplits = new HashSet<string>();
}

onStart
{
	vars.completedSplits.Clear();
}

start
{
	return (current.activeChapterIndex == 0 && current.checkpointIndex == 0 && current.devCheckpointIndex == 1);
}

update
{	
	vars.Helper.Update();
	vars.Helper.MapPointers();
}

split
{
	string setting = "";

	if (current.activeChapterIndex != old.activeChapterIndex || current.checkpointIndex != old.checkpointIndex || current.devCheckpointIndex != old.devCheckpointIndex)
	{
		setting = current.activeChapterIndex + "_" + current.checkpointIndex + "_" + current.devCheckpointIndex;
	}
	
	return (settings.ContainsKey(setting) && settings[setting] && vars.completedSplits.Add(setting));
}

isLoading
{
	return (current.isLoading || current.isPaused || current.isMenuMusic || current.IsSkipCinematicsAvailable);
}

reset
{
	return current.activeChapterIndex == -1 && current.isMenuMusic;
}

exit
{
}
