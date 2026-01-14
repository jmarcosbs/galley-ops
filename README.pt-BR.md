# Galley Ops

Galley Ops reúne todos os módulos que construí para digitalizar a operação de um restaurante familiar: da vitrine pública ao envio da comanda e emissão fiscal. O sistema nasceu como um PWA simples que só imprimia pedidos e evoluiu para uma plataforma completa de cardápio, pedidos, contas, NFC‑e e gerenciamento interno.

> Idealização, desenvolvimento e evolução contínua são feitos por mim, de forma independente e sem custo para o restaurante.

## Visão rápida

- **Landing em Astro** com SEO, schema.org e alternância PT/EN/ES.
- **Menu A4** pronto para impressão com tipografia editorial e cortes configurados.
- **Aplicativo interno** (Next.js 16, Tailwind, MUI, Radix, PWA) para montagem de pedidos com login e permissões por função.
- **Backend Django 5** com DRF, Channels, Celery e emissão NFC‑e em produção via SEFAZ.
- **Driver FastAPI + pywin32** que despacha comandas e contas para impressoras ESC/P.
- **Coleções Postman** versionadas para testar todo o ecossistema.

```
.
├── landing/      # Landing page Astro (cardápio público e SEO)
├── a4-menu/      # Versão impressa do cardápio
├── app/          # Aplicativo interno (Next.js PWA)
├── service/      # Backend Django + Celery + Channels
├── driver/       # API de impressão FastAPI
└── docs/         # Postman collections e instruções rápidas
```

## Destaques por módulo

### Landing (`landing/`)
- Construída em **Astro 5** com suporte a SSR estático, sitemap e metadados completos.
- Textos e CTAs traduzidos em PT‑BR, EN e ES com persistência da escolha via localStorage.
- Página `/menu` consome `PUBLIC_MENU_API` para mostrar o mesmo cardápio exposto no app.
- Makefile com alvos `build`, `deploy` e comandos para controlar o Nginx da VPS.

### Cardápio impresso (`a4-menu/`)
- HTML/CSS puro com `@page` configurado para A4, margens e tipografia Playfair + Manrope.
- Layout em “livro” com colunas responsivas; uso para gerar PDF e levar para a mesa.

### App interno (`app/`)
- **Next.js 16** exportado como estático com PWA habilitado por `@ducanh2912/next-pwa`.
- UI em Tailwind + Radix + componentes do shadcn, temas customizados para o restaurante.
- Hooks (`useMenu`, `useTables`, `useAuth`) cuidam de chamadas autenticadas, WebSockets e QR code scanner.
- `OrderContext` centraliza o estado do pedido, guarda dados em localStorage e gera payload idempotente para o backend.
- Dashboard com impressão do serviço (10%) e board em tempo real das mesas através do canal WS.

### Backend (`service/`)
- **Django 5 + DRF** para API REST, Channels para WebSockets de mesas e Celery dividido em filas (`default`, `notifications`, `printing`).
- Apps principais: `menu` (categorias, traduções e acompanhamentos), `orders` (tickets, settlements, dashboards) e `nfce` (integração SEFAZ com certificado A1 usando PyNFe).
- Emite notas fiscais eletrônicas de consumidor (NFC‑e) oficiais do governo brasileiro em produção.
- Permite logins específicos (garçom, caixa, administrador) com permissões ajustadas a cada função.
- Tasks assíncronas notificam Telegram, disparam impressões e mantêm o painel sincronizado.
- `docker-compose.yml` sobe web, ASGI, três workers Celery e Redis para desenvolvimento.

### Driver de impressão (`driver/`)
- **FastAPI** que recebe pedidos/contas/resumos e os repassa para scripts pywin32.
- Scripts separados para copa, cozinha, conta e relatório diário (`print_bar.py`, `print_kitchen.py`, `print_bill.py`, `print_dashboard.py`).
- Usa variáveis de ambiente para selecionar impressoras e aplica tratamento de erros padronizado.

### Documentação (`docs/`)
- Coleções Postman (`service.postman_collection.json`, `printer.postman_collection.json`) para testar autenticação, pedidos, settlements, dashboards e o driver.
- README dentro de `docs/` explica variáveis de ambiente sugeridas e como importar as coleções.

## Como rodar

> Cada pasta tem seu próprio README/Makefile, mas deixei um resumo rápido aqui.

1. **Backend**: configurar `.env`, instalar dependências e subir com `docker compose up` em `service/`. Ele expõe a API em `http://localhost:8002` e o WS em `http://localhost:8006`.
2. **App interno**: em `app/`, criar `.env.local` apontando `NEXT_PUBLIC_API_BASE_URL` e `NEXT_PUBLIC_WS_BASE_URL`, instalar deps (`npm install`) e rodar `npm run dev`.
3. **Landing**: em `landing/`, `npm install` e `npm run dev` (porta padrão 4321). O Makefile ajuda a buildar e publicar.
4. **Driver**: em `driver/`, criar `.env` com as impressoras, instalar deps (`pip install -r requirements.txt`) e iniciar `uvicorn main:app`.
5. **Cardápio A4**: abrir `a4-menu/index.html` no navegador ou gerar PDF pelo próprio browser.

## Status e próximos passos

- Sistema em funcionamento e já utilizado diariamente, substituindo totalmente o fluxo em papel e caneta.
- Entrega ganhos reais de velocidade no atendimento e no fechamento de contas.
- Continuação do desenvolvimento com melhorias graduais (testes automatizados, monitoramento, novos relatórios).
- Projeto segue ativo e evoluindo.