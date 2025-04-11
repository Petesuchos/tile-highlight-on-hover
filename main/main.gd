extends Node2D


@export var map : TileMapLayer
@export var highlight: ColorRect
var last_hovered_tile: Vector2i = Vector2i(-1, -1)

func _ready():
	# Verifica se o nó de highlight foi encontrado
	if not highlight:
		printerr("Nó 'Highlight' não encontrado! Crie um ColorRect com este nome como filho de Main.")
		return # Impede a execução do resto se o highlight não existir

	# Verifica se o TileMap tem um TileSet associado
	if not map.tile_set:
		printerr("O TileMapLayer 'Map' não tem um TileSet configurado.")
		# Você pode querer desabilitar o processamento ou retornar aqui também
		# set_process(false)
		return

	# Ajusta o tamanho do highlight para ser igual ao tamanho do tile do TileMap
	# É crucial que o tamanho do highlight corresponda ao tamanho do tile!
	highlight.size = map.tile_set.tile_size

	# Garante que o highlight comece invisível
	highlight.visible = false


func _process(_delta):
	# Se o highlight não foi configurado corretamente no _ready, não faz nada.
	if not highlight or not map.tile_set:
		return

	# 1. Obter a posição global do mouse
	var global_mouse_pos = get_global_mouse_position()

	# 2. Converter a posição global do mouse para as coordenadas locais do TileMapLayer
	var map_local_mouse_pos = map.to_local(global_mouse_pos)

	# 3. Converter a posição local no TileMap para coordenadas de tile (ex: (3, 5))
	var current_tile_coords: Vector2i = map.local_to_map(map_local_mouse_pos)

	# --- Opcional: Checar se o mouse está fora da janela ---
	# Pega o retângulo da viewport atual
	# var viewport_rect = get_viewport().get_visible_rect()
	# Pega a posição do mouse relativa à viewport
	# var mouse_in_viewport = viewport_rect.has_point(get_viewport().get_mouse_position())
    #
	# if not mouse_in_viewport:
	#	 if highlight.visible:
	#		 highlight.visible = false
	#		 last_hovered_tile = Vector2i(-1, -1) # Reseta o último tile
	#	 return # Sai da função se o mouse está fora da janela

	# 4. Verificar se o tile sob o mouse mudou desde o último frame
	if current_tile_coords != last_hovered_tile:
		# Atualiza o último tile conhecido
		last_hovered_tile = current_tile_coords

		# 5. Calcular a posição GLOBAL do canto superior esquerdo do tile atual
		#    map.map_to_local() dá a posição relativa ao TileMap
		#    map.to_global() converte essa posição local do TileMap para global
		var tile_global_pos = map.to_global(map.map_to_local(current_tile_coords))

		# 6. Posicionar o nó de highlight nessa posição global
		highlight.global_position = Vector2(tile_global_pos.x - 32, tile_global_pos.y - 32)  

		# 7. Tornar o highlight visível (caso estivesse invisível)
		if not highlight.visible:
			highlight.visible = true

	# --- Outra forma de esconder se o mouse sair (mais simples que checar viewport) ---
	# Pode ser útil se map.local_to_map() retornar coordenadas estranhas fora do mapa.
	# Checa se o mouse está realmente sobre a área do TileMap (aproximado)
	# var map_rect_global = map.get_global_rect() # Pega o retângulo global aproximado do TileMap
	# if not map_rect_global.has_point(global_mouse_pos):
	#	 if highlight.visible:
	#		 highlight.visible = false
	#		 last_hovered_tile = Vector2i(-1,-1) # Reseta

# --- Opcional: Esconder o highlight quando o mouse sai da janela ---
# Você também pode conectar o sinal "mouse_exited" da Viewport (raiz da cena)
# a uma função aqui para esconder o highlight de forma mais robusta.
# Exemplo de como conectar via código (faça isso no _ready):
# get_viewport().mouse_exited.connect(_on_mouse_exited_viewport)

# func _on_mouse_exited_viewport():
#	 if highlight and highlight.visible:
#		 highlight.visible = false
#		 last_hovered_tile = Vector2i(-1, -1) # Reseta