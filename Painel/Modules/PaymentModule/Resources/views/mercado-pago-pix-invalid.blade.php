@extends('paymentmodule::layouts.master')

@section('content')
    <div class="pix-container">
        <div class="pix-card">
            <h1 class="pix-title">Pagamento PIX</h1>
            <p class="pix-subtitle">Não encontramos as informações necessárias para gerar o QR Code.</p>

            <div class="pix-help">
                <p>
                    Abra este pagamento usando o link completo que contém o parâmetro <code>payment_id</code>.
                </p>
                <p>
                    Se você já tem o link, cole abaixo. Aceitamos o link inteiro ou apenas o UUID do pagamento.
                </p>
            </div>

            <div class="pix-form">
                <input id="pix-input" class="pix-input" type="text" placeholder="Cole o link completo ou apenas o payment_id" />
                <button id="pix-go" class="pix-btn primary">Continuar</button>
            </div>

            <small class="pix-hint">Exemplo de link: https://seu-dominio/payment/mercadopago_pix/pay?payment_id=00000000-0000-0000-0000-000000000000</small>
        </div>
    </div>

    <script>
        (function(){
            const input = document.getElementById('pix-input');
            const btn = document.getElementById('pix-go');

            function extractId(value){
                // Tenta extrair payment_id de uma URL
                try{
                    const url = new URL(value);
                    const pid = url.searchParams.get('payment_id');
                    if (pid) return pid;
                }catch(e){/* não é URL */}
                // Se não for URL, retorna o próprio valor (UUID)
                return value.trim();
            }

            function isUuid(v){
                return /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(v);
            }

            function go(){
                const raw = input.value || '';
                const id = extractId(raw);
                if (!isUuid(id)) {
                    alert('Informe um payment_id válido (UUID) ou cole o link completo.');
                    return;
                }
                const url = new URL(window.location.href);
                url.searchParams.set('payment_id', id);
                window.location.assign(url.toString());
            }

            btn && btn.addEventListener('click', go);
            input && input.addEventListener('keydown', (e)=>{ if (e.key === 'Enter') go(); });
        })();
    </script>
@endsection

@push('script')
    <style>
        :root {
            --bg: #0f172a; /* slate-900 */
            --card: #111827; /* gray-900 */
            --text: #e5e7eb; /* gray-200 */
            --muted: #9ca3af; /* gray-400 */
            --primary: #22c55e; /* green-500 */
            --primary-contrast: #052e16; /* green-950 */
        }
        body { background: var(--bg); color: var(--text); margin: 0; }
        .pix-container { min-height: 100vh; display:flex; align-items:center; justify-content:center; padding: 1rem; }
        .pix-card { background: var(--card); border-radius: 12px; padding: 2rem; width: 100%; max-width: 520px; box-shadow: 0 10px 30px rgba(0,0,0,.35); text-align:center; }
        .pix-title { font-size: 1.25rem; margin: 0 0 .25rem; font-weight: 700; }
        .pix-subtitle { color: var(--muted); margin: 0 0 1rem; font-size: .95rem; }
        .pix-help { color: var(--text); text-align:left; background:#0b1220; border:1px solid #334155; padding: .75rem; border-radius: 8px; margin-bottom: 1rem; }
        .pix-form { display:flex; gap: .5rem; margin-top: .75rem; }
        .pix-input { flex:1; padding: .6rem .8rem; border-radius: 8px; border: 1px solid #334155; background:#0b1220; color: var(--text); font-size: .9rem; }
        .pix-btn { padding: .6rem 1rem; border-radius: 8px; border: none; cursor: pointer; background:#374151; color: var(--text); font-weight: 700; }
        .pix-btn.primary { background: var(--primary); color: var(--primary-contrast); }
        .pix-hint { display:block; color: var(--muted); margin-top: .5rem; font-size: .8rem; }
    </style>
@endpush
