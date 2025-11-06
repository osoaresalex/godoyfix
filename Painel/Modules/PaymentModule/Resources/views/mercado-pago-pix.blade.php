@extends('paymentmodule::layouts.master')

@section('content')
    <div class="pix-container">
        <div class="pix-card">
            <img class="pix-logo" src="{{ $business_logo }}" alt="{{ $business_name }}" />
            <h1 class="pix-title">{{ 'Please do not refresh this page...' }}</h1>
            <p class="pix-subtitle">{{ 'Pague via PIX no seu aplicativo do banco' }}</p>

            @if(!empty($qrCodeBase64))
                <img class="pix-qr" src="data:image/png;base64,{{ $qrCodeBase64 }}" alt="QR Code PIX" />
            @else
                <p class="pix-error">{{ 'Não foi possível gerar o QR Code. Tente novamente.' }}</p>
            @endif

            @if(!empty($qrCode))
                <div class="pix-copy">
                    <input id="pix-code" class="pix-input" type="text" readonly value="{{ $qrCode }}" />
                    <button id="pix-copy-btn" class="pix-btn">{{ 'Copiar código PIX' }}</button>
                </div>
                <small class="pix-hint">{{ 'Use o QR Code acima ou copie o código para pagar no app do seu banco.' }}</small>
            @endif

            <div class="pix-actions">
                <button id="pix-check-btn" class="pix-btn primary">{{ 'Já paguei' }}</button>
            </div>
        </div>
    </div>

    <script>
        (function(){
            const paymentId = "{{ $data->id }}";
            const checkUrl = "{{ route('mercadopago_pix.check-status') }}";
            const copyBtn = document.getElementById('pix-copy-btn');
            const codeEl = document.getElementById('pix-code');
            const checkBtn = document.getElementById('pix-check-btn');

            function copyPix(){
                if (!codeEl) return;
                codeEl.select();
                codeEl.setSelectionRange(0, 99999);
                try {
                    document.execCommand('copy');
                    copyBtn && (copyBtn.textContent = '{{ 'Copiado!' }}');
                    setTimeout(()=>{ copyBtn && (copyBtn.textContent = '{{ 'Copiar código PIX' }}'); }, 2000);
                } catch (e) {
                    console.error('Copy failed', e);
                }
            }

            async function checkStatus(){
                try {
                    const url = new URL(checkUrl, window.location.origin);
                    url.searchParams.set('payment_id', paymentId);
                    const res = await fetch(url.toString(), { method: 'GET', headers: { 'Accept': 'application/json' }});
                    if (!res.ok) return;
                    const data = await res.json();
                    if (data.paid && data.redirect) {
                        window.location.replace(data.redirect);
                    }
                } catch (err) {
                    console.warn('Status check failed', err);
                }
            }

            copyBtn && copyBtn.addEventListener('click', copyPix);
            checkBtn && checkBtn.addEventListener('click', checkStatus);

            // Poll every 3 seconds
            const poll = setInterval(checkStatus, 3000);
            window.addEventListener('beforeunload', ()=> clearInterval(poll));
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
        .pix-logo { height: 48px; width: auto; object-fit: contain; margin-bottom: .5rem; }
        .pix-title { font-size: 1.1rem; margin: .25rem 0 0; font-weight: 600; }
        .pix-subtitle { color: var(--muted); margin: .25rem 0 1rem; font-size: .95rem; }
        .pix-qr { display:block; margin: 1rem auto; width: 240px; height: 240px; background:#fff; padding: 12px; border-radius: 8px; }
        .pix-copy { display:flex; gap: .5rem; margin-top: .75rem; }
        .pix-input { flex:1; padding: .6rem .8rem; border-radius: 8px; border: 1px solid #334155; background:#0b1220; color: var(--text); font-size: .85rem; }
        .pix-btn { padding: .6rem 1rem; border-radius: 8px; border: none; cursor: pointer; background:#374151; color: var(--text); font-weight: 600; }
        .pix-btn.primary { background: var(--primary); color: #052e16; }
        .pix-btn:hover { filter: brightness(1.05); }
        .pix-hint { display:block; color: var(--muted); margin-top: .35rem; }
        .pix-actions { margin-top: 1rem; display:flex; justify-content:center; }
        .pix-error { color: #f87171; }
    </style>
@endpush
