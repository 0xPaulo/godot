using Godot;
using System;

public partial  class MyNode3D : Node3D
{
	private CanvasLayer UI;

	public override void _Ready()
	{
		// Carrega a referência ao nó UI
		UI = GetNode<CanvasLayer>("SubViewportContainer/SubViewport/CanvasLayer/UI");
		
		// Esconde o retângulo de colisão inicialmente
		UI.Visible = false;
	}

	public override void _Process(double delta)
	{
		// Este método é chamado a cada frame, mas neste caso, não há lógica específica para ser adicionada aqui.
	}

	// Supondo que este método seja chamado quando o evento 'boneco_player_hit' ocorrer
	public void OnBonecoPlayerHit()
	{
		//UI.Visible = true;
		//await ToSignal(GetTree(), "idle_frame"); // Espera um frame para simular o delay
		//UI.Visible = false;
	}
}
