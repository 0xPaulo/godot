using Godot;
using System;

public partial class MainNode : Node3D
{
    private Control hitRect;
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        hitRect = GetNode<Control>("SubViewportContainer/SubViewport/CanvasLayer/UI");
        hitRect.Visible = false;
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }
    private async void _on_boneco_player_hit()
    {
        hitRect.Visible = true;
        await ToSignal(GetTree().CreateTimer(0.2f), "timeout");
        hitRect.Visible = false;
    }
}
