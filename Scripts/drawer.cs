using Godot;
using System;

public partial class drawer : Control
{
	private bool isOpen = false;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void _on_WorkStationMenu_pressed(){
		ToggleMenu();
	}

	public void ToggleMenu(){
		isOpen = !isOpen;

		if (isOpen)
		{
			Position += new Vector2(57f,0f);
		}else{
			Position += new Vector2(-57f,0f);
		}
	}


}
