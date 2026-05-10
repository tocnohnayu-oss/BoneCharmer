shader_type canvas_item;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    // Заменяем цвет на белый, сохраняя прозрачность (альфа-канал)
    COLOR = vec4(1.0, 1.0, 1.0, color.a * 0.5);
}
