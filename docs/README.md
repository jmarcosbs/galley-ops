# Documentacao do diretorio `docs`

Este diretorio guarda as colecoes Postman usadas para testar rapidamente os servicos do ecossistema Marinheiros sem depender do aplicativo ou da dashboard. Use-o para importar requests pre-configurados e substituir apenas os valores sensiveis (URLs, tokens e UUIDs reais).

## Como importar no Postman
1. Abra o Postman e clique em **Import**.
2. Escolha a aba **File** e selecione o JSON desejado dentro de `docs/`.
3. Defina as variaveis listadas abaixo em **Variables** apos a importacao.
4. Execute os requests conforme necessario.

> Recomendacao: mantenha uma collection environment (ex.: `Local`, `Staging`) para facilitar a troca de `baseUrl`/`base_url` e credenciais quando alternar entre ambientes.

## `service.postman_collection.json` (Marinheiros API)

Colecao principal do backend Django exposto no servico `service/`. O valor padrao de `baseUrl` eh `http://localhost:8002`, o mesmo utilizado pelo `docker-compose.yml` local.

### Variaveis suportadas
- `baseUrl`: URL base da API (ex.: `http://localhost:8002`).
- `accessToken` e `refreshToken`: tokens JWT emitidos pelos endpoints de autenticacao.
- `dishUuid`, `sideDishUuid`, `dishOrderUuid`, `settlementUuid`: UUIDs reais retornados pela API. Substitua pelos valores obtidos nas chamadas de lista para evitar erros 404.

### Endpoints incluidos
- `POST /api/users/token/`: autentica usuario (SimpleJWT) e retorna `access`/`refresh`.
- `POST /api/users/token/refresh/`: renova o `access` sem precisar reenviar credenciais.
- `GET /api/menu/`: retorna cardapio completo com categorias, pratos e acompanhamentos.
- `POST /api/order/`: abre ou reaproveita um ticket e registra novos itens.
- `GET /api/open-tables/`: lista mesas com pedidos em aberto ou parcialmente pagos (requer JWT).
- `POST /api/ticket-settlement/`: processa fechamento total ou parcial; o status vira `closed` ao zerar itens ou `partially_paid` caso contrario. **Importante:** o backend exige `additions_percentage = 10` (acrescimo fixo) e aceita `discounts_percentage` opcional.
- `POST /api/tickets/update/`: atualiza numero/localizacao da mesa enquanto houver ticket aberto.
- `POST /api/ticket-settlement/{{settlementUuid}}/reprint/`: dispara nova impressao da conta via driver integrado.

Os corpos de exemplo disponibilizam o formato aceito pelo backend. Ajuste `ticket`, `dishes`, quantidades e notas de acordo com o fluxo real capturado pela dashboard ou pelo app dos garcons.

## `printer.postman_collection.json` (Printer API)

Colecao dedicada ao driver de impressao em `driver/`. Por padrao usa `base_url = http://localhost:8000` (porta exposta pelo `uvicorn main:app --host 0.0.0.0 --port 8000`).

### Endpoints incluidos
- `GET /health`: verifica se o driver esta online.
- `POST /print-bar`: envia apenas itens do departamento `copa` para a impressora configurada em `BAR_PRINTER`.
- `POST /print-kitchen`: imprime itens `cozinha` na impressora configurada em `DEFAULT_PRINTER`.
- `POST /print-bill`: imprime a conta final (itens, servico, totais e dados fiscais) usando `BILL_PRINTER`/logo configurado.

Os bodies contidos no JSON seguem os mesmos exemplos presentes em `driver/README.md`. Edite apenas os campos dinamicos (mesa, itens, impostos, chaves NFC-e etc.) para refletir o pedido real antes de chamar o endpoint.

---

Caso crie novas colecoes ou atualize os endpoints existentes, lembre-se de commitar tanto o arquivo `.postman_collection.json` quanto eventuais instrucoes adicionais aqui no `README.md` para manter o time alinhado.
