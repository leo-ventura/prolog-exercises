% border(place, [bordering_place1, bordering_place2, ...])
% `place` representa um lugar (país, estado, ou qualquer coisa que possa ser representada num mapa)
% e [bordering_place1, bordering_place2, ...] é uma lista de lugares que fazem fronteira com `place`
% Analogamente, podemos imaginar `place` como sendo um nó de um grafo
% e [bordering_place1, bordering_place2, ...] como a lista de adjacencias desse nó
border(brasil, [guianaFrancesa, suriname, guiana, venezuela, colombia, peru, bolivia, paraguai, argentina, uruguai]).
border(guianaFrancesa, [brasil, suriname]).
border(suriname, [guianaFrancesa, guiana, brasil]).
border(guiana, [suriname, venezuela, brasil]).
border(venezuela, [guiana, colombia, brasil]).
border(colombia, [venezuela, brasil, equador, peru]).
border(equador, [colombia, peru]).
border(peru, [brasil, colombia, equador, brasil, bolivia, chile]).
border(bolivia, [brasil, peru, chile, argentina, paraguai]).
border(chile, [peru, bolivia, argentina]).
border(argentina, [uruguai, brasil, paraguai, bolivia, chile]).
border(paraguai, [brasil, bolivia, argentina]).
border(uruguai, [brasil, argentina]).

% Define as cores a serem utilizadas
% A ordem das cores aqui afeta a ordem das cores dos lugares por causa do match
color(red).
color(green).
color(blue).
color(white).

% can_use_color faz uma "iteração" por cada fronteira definida na lista passada como primeiro argumento.
% Para cada valor da lista, recuperado pela cabeça `BORDERING_PLACE` da lista,
% é checado se esse lugar está colorido com a cor alvo, identificada pelo argumento `COLOR`.
% Além disso, `PLACES_COLORS` é um dicionário (hashmap) que mapeia cada lugar a uma cor
% no formato colors{lugar1:cor1, lugar2:cor2, lugar3:cor3, lugar4:cor4, lugar5: cor2, ...}
% Essa função irá iterar até encontrar uma lista vazia de lugares para iterar.
% Se chegarmos no caso base, terminamos a execução sem falhar a comparação
% BORDERING_PLACE_COLOR \= COLOR, ou seja, não tem nenhum país na fronteira usando a cor `COLOR`.
% Outro ponto importante é lembrar que `PLACES_COLORS.get(BORDERING_PLACE)` retornará false
% se `BORDERING_PLACE` não for uma chave no dicionário `PLACES_COLORS`.
% Se isso acontecer, BORDERING_PLACE_COLOR = PLACES_COLORS.get(BORDERING_PLACE) falhará,
% fazendo que o `cut` não seja alcançado, e o programa então irá para o próximo match,
% que apenas continua a iteração com os países restantes.
can_use_color([], _, _).	% caso base
can_use_color([BORDERING_PLACE | REMAINING_PLACES], PLACES_COLORS, COLOR) :-
    % BORDERING_PLACE_COLOR = PLACES_COLORS.get(BORDERING_PLACE, black), !,
    % A partir da versão 8.3.15, Dict possui a função get/2, definida como
    % get(?KeyPath, +Default). Essa versão ainda não está no release estável da linguagem,
    % então a deixo aqui apenas como comentário para o futuro.
    BORDERING_PLACE_COLOR = PLACES_COLORS.get(BORDERING_PLACE), !,
    % Compara se a cor que estou testando já foi tomada por algum lugar que faz fronteira
    BORDERING_PLACE_COLOR \= COLOR,
    % Chama recursivamente para o lugares restantes
    can_use_color(REMAINING_PLACES, PLACES_COLORS, COLOR).

% Cobre o caso de falharmos em recuperar o lugar no dicionário.
% Ou seja, ele ainda não teve cor atribuída, então podemos ignorá-lo
% e continuar a checagem para os lugares restantes.
can_use_color([_ | REMAINING_PLACES], PLACES_COLORS, COLOR) :-
    can_use_color(REMAINING_PLACES, PLACES_COLORS, COLOR).

% find_color busca por uma cor disponível para ser usada na coloração do lugar atual.
% Essa cor é retornada dentro do Dict `PLACES_COLORS`,
% uma tabela hash que mapeia chave-valor, no formato explicado anteriormente,
% por meio de um put/2, que recebe a chave como primeiro parâmetro, e o valor como segundo.
% No nosso caso, dado o mapeamento explicado anteriormente, temos a chave como o lugar atual,
% que estamos tentando alocar uma cor, e o valor como a cor que conseguimos alocar.
% Assim, em `do_colorize`, que chama esse functor, conseguimos recuperar essa cor pela chave.
find_color(PLACE, PLACES_COLORS, PLACES_COLORS.put(PLACE, COLOR)) :-
    % Recupera os lugares que fazem fronteira, definidos na parte inicial do programa.
    % Esses lugares são guardados na lista `BORDERING_PLACES`.
    border(PLACE, BORDERING_PLACES),
    % Recupera uma cor, aqui a ordem das cores definidas anteriormente afetará o resultado do programa,
    % pois iremos dar match na ordem especificada.
    % Começamos tentando a cor `red`.
    color(COLOR),
    % Em seguida o functor can_use_color é chamado para sabermos se essa cor pode ser usada.
    % Se essa função não falhar, sabemos que podemos usar a cor especificada para o lugar atual.
    % No entanto, ainda não sabemos se funcionará para todos os outros casos daqui pra frente,
    % então precisamos ainda deixar aberta a possibilidade de termos outras possibilidades
    % de cor para o lugar atual.
    % Além disso, se `can_use_color` falhar em algum momento,
    % sabemos que não podemos usar a cor especificada por ter algum vizinho com essa cor.
    % Por fim, vale lembrar que tentaremos as 4 cores na ordem: red, green, blue, white.
    can_use_color(BORDERING_PLACES, PLACES_COLORS, COLOR).


% Caso base, não existem mapas para colorir
do_colorize([], _, []).
% Functor de colorização, recebe como primeiro argumento os lugares a colorir
% O segundo arugmento, `PLACES_COLORS`, é o dicionario que mapeia os lugares às suas respectivas cores
% O terceiro e último argumento é nosso parâmetro de saída, que retornará nosso output no formato
% [place(lugar1, red), place(lugar2, green), ...]
% Nesse caso, `place` age apenas como um encapsulador para facilitar a nossa visualização da saída
do_colorize([PLACE | REMAINING_PLACES], PLACES_COLORS, [place(PLACE, COLOR) | PLACES_COLORIZED]) :-
    % Primeiro procuramos qual cor está disponível para colorirmos
    % o lugar que está na cabeça da nossa lista de lugares
    % Como dito anteriormente, a cor do nosso lugar de agora estará dentro do Dict `NEW_PLACES_COLORS`
    % que age como nosso parâmetro de saída
    find_color(PLACE, PLACES_COLORS, NEW_PLACES_COLORS),
    % Então recuperamos a cor atribuída ao nosso lugar no dicionário utilizando get/1
    % que, dada uma chave (no nosso caso o lugar), retorna o valor mapeado por essa chave (cor)
    % pela função hash.
    % A cor também poderia ser recuperada diretamente no argumento, fazendo
    % `place(PLACE, NEW_PLACES_COLORS.get(PLACE))` ao invés de `place(PLACE, COLOR)`,
    % mas acredito que assim fica mais legível,
    % evitando que a definição de `do_colorize` fique muito grande
    COLOR = NEW_PLACES_COLORS.get(PLACE),
    % Chama a colorização para os lugares restantes da lista passada como argumento pelo usuário
    % Passa o novo dicionário, contendo o lugar que colorimos nessa iteração, para a próxima iteração
    % A saída da recursão, uma lista definida como `PLACES_COLORIZED`,
    % é recebida e repassada como tail na nossa saída, no terceiro argumento.
    % Como queremos só o primeiro resultado, colocamos um `cut` para finalizar a execução
    do_colorize(REMAINING_PLACES, NEW_PLACES_COLORS, PLACES_COLORIZED), !.

% Age como uma API, que inicializa o Dict e chama o functor de colorização.
% Abstraindo o Dict de quem faz a query.
% Esse é o functor que deve ser utilizado para fazer a query.
% Um exemplo de execução seria:
% colorize([brasil, argentina], X)
% Que teria como saída:
% X = [place(brasil, red), place(argentina, green)]
colorize(PLACES, COLORIZED_PLACES) :- do_colorize(PLACES, colors{}, COLORIZED_PLACES).
