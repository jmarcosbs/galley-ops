# 🚢 🍤 Galley Ops

Galley Ops is a fully bootstrapped platform to digitize a family-owned restaurant, spanning from the public landing page to order dispatch and fiscal compliance. It began as a simple ticket-printing PWA and evolved into a complete system for menu management, orders, settlements, NFC-e emission, and internal dashboards.

## Quick overview

- **Astro landing page** with SEO, schema.org, and PT/EN/ES language switcher.
- **A4 printable menu** with editorial typography and trim marks.
- **Internal app** (Next.js 16, Tailwind, MUI, Radix, PWA) for building orders with role-based logins.
- **Django 5 backend** (DRF, Channels, Celery) issuing NFC‑e via SEFAZ in production.
- **FastAPI + pywin32 driver** that prints tickets and bills on ESC/P printers.
- **Postman collections** covering the entire ecosystem.

```
.
├── landing/      # Astro landing page (public menu + SEO)
├── a4-menu/      # Printable A4 menu
├── app/          # Internal Next.js PWA
├── service/      # Django backend + Celery + Channels
├── driver/       # FastAPI printing bridge
└── docs/         # Postman collections and docs
```

## Module highlights

### Landing (`landing/`)
- Built with **Astro 5** (static SSR), sitemap, and SEO-ready metadata.
- PT‑BR / EN / ES copy persisted via localStorage for returning visitors.
- `/menu` consumes `PUBLIC_MENU_API`, mirroring the same menu used internally.
- Makefile targets (`build`, `deploy`, nginx helpers) streamline deployments.

### Printable menu (`a4-menu/`)
- Pure HTML/CSS with tuned `@page`, margins, and Playfair + Manrope typography.
- Book-style layout (responsive columns) used to generate PDFs for the tables.

### Internal app (`app/`)
- **Next.js 16** exported as a static PWA (using `@ducanh2912/next-pwa`).
- Tailwind + Radix + shadcn components themed for the restaurant identity.
- Hooks (`useMenu`, `useTables`, `useAuth`) handle authenticated fetches, WebSockets, and QR scanning.
- `OrderContext` persists order data locally and emits idempotent payloads.
- Dashboard prints the 10% service report and shows tables in real time.

### Backend (`service/`)
- **Django 5 + DRF** REST API, Channels for WebSockets, Celery queues (`default`, `notifications`, `printing`).
- Core apps: `menu`, `orders`, `nfce` (PyNFe + certificate A1 for SEFAZ).
- Issues official NFC‑e invoices in production.
- Role-based logins (waiter, cashier, admin) with tailored permissions.
- Celery tasks send Telegram alerts, trigger printers, and refresh open tables.
- `docker-compose.yml` runs web, ASGI, three Celery workers, and Redis locally.

### Printing driver (`driver/`)
- **FastAPI** service that receives payloads and hands them to pywin32 scripts.
- Dedicated scripts for bar, kitchen, bill, and daily dashboard printing.
- Printer selection via environment variables with standardized error handling.

### Docs (`docs/`)
- Postman collections (`service.postman_collection.json`, `printer.postman_collection.json`) covering auth, menu, orders, settlements, dashboard, and printer endpoints.
- README explains the required environment variables and import instructions.

## How to run

> Each directory ships its own README/Makefile; below is the condensed version.

1. **Backend** – configure `.env`, install deps, run `docker compose up` in `service/`. API lives at `http://localhost:8002`, WebSocket at `http://localhost:8006`.
2. **Internal app** – inside `app/`, create `.env.local` with `NEXT_PUBLIC_API_BASE_URL` + `NEXT_PUBLIC_WS_BASE_URL`, then `npm install && npm run dev`.
3. **Landing** – `npm install && npm run dev` in `landing/` (port 4321). Makefile helps deploy.
4. **Driver** – add `.env` with printer names, `pip install -r requirements.txt`, run `uvicorn main:app`.
5. **A4 menu** – open `a4-menu/index.html` in the browser or print/save as PDF.

## Status & next steps

- Live in production, fully replacing the old paper-and-pen workflow.
- Tangible gains in service speed and bill settlement.
- Roadmap: automated tests, monitoring, new operational reports.
- The project remains active and keeps evolving.
