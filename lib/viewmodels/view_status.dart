/// Os 4 estados que toda tela com API precisa tratar.
/// (Antes se chamava SearchStatus e ficava dentro do search_viewmodel.)
enum ViewStatus { inicial, carregando, sucesso, vazio, erro }