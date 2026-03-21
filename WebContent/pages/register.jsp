
<%@ page contentType="text/html;charset=UTF-8" %> 

<!DOCTYPE html>

<html class="light" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700;800;900&amp;family=Manrope:wght@200;300;400;500;600;700;800&amp;family=Lexend:wght@100;200;300;400;500;600;700;800;900&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "tertiary-fixed-dim": "#f0f1f1",
              "on-error": "#ffefee",
              "surface-container-low": "#f1f1f1",
              "secondary-fixed-dim": "#ebcdcd",
              "primary-container": "#ff766d",
              "primary": "#ab2b29",
              "error": "#b31b25",
              "surface-container-lowest": "#ffffff",
              "outline": "#767777",
              "primary-dim": "#9a1e1f",
              "on-surface-variant": "#5a5c5c",
              "on-primary-container": "#4f0005",
              "surface-dim": "#d3d5d5",
              "inverse-surface": "#0d0e0f",
              "error-dim": "#9f0519",
              "on-tertiary-container": "#616263",
              "surface-bright": "#f7f6f6",
              "tertiary": "#5a5c5c",
              "on-primary": "#ffefed",
              "on-error-container": "#570008",
              "surface-container": "#e8e8e8",
              "inverse-primary": "#fe675f",
              "on-secondary-fixed": "#4e3a3b",
              "secondary-container": "#fadbdb",
              "secondary-fixed": "#fadbdb",
              "primary-fixed": "#ff766d",
              "on-tertiary-fixed-variant": "#6c6d6e",
              "on-primary-fixed": "#000000",
              "outline-variant": "#adadad",
              "on-secondary-container": "#624c4d",
              "on-secondary": "#ffefef",
              "secondary-dim": "#604a4b",
              "on-primary-fixed-variant": "#600007",
              "secondary": "#6c5656",
              "error-container": "#fb5151",
              "tertiary-fixed": "#ffffff",
              "surface-tint": "#ab2b29",
              "on-background": "#2d2f2f",
              "on-secondary-fixed-variant": "#6c5656",
              "inverse-on-surface": "#9c9d9d",
              "surface-variant": "#dcdddd",
              "background": "#f7f6f6",
              "surface-container-high": "#e2e2e3",
              "on-tertiary": "#f2f3f3",
              "tertiary-dim": "#4e5050",
              "surface": "#f7f6f6",
              "on-surface": "#2d2f2f",
              "surface-container-highest": "#dcdddd",
              "tertiary-container": "#ffffff",
              "primary-fixed-dim": "#f7625a",
              "on-tertiary-fixed": "#4f5051"
            },
            fontFamily: {
              "headline": ["Space Grotesk"],
              "body": ["Manrope"],
              "label": ["Lexend"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
      .material-symbols-outlined {
        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
      }
      .bg-noir-gradient {
        background: linear-gradient(45deg, #ab2b29 0%, #ff766d 100%);
      }
      .asymmetric-clip {
        clip-path: polygon(0 0, 100% 0, 100% 85%, 0% 100%);
      }
    </style>
</head>
<body class="bg-background text-on-surface font-body selection:bg-primary-container selection:text-on-primary-container">
<!-- Top Navigation Bar -->
<jsp:include page="../components/header.jsp" />
<!-- New Hero Section based on IMAGE_11 -->
<section class="relative min-h-screen bg-primary overflow-hidden py-32 flex items-center">
<!-- Abstract background pattern from IMAGE_11 -->
<div class="absolute top-0 right-0 w-1/2 h-full opacity-10 pointer-events-none">
<svg class="w-full h-full fill-white" viewbox="0 0 100 100">
<rect height="100" width="10" x="20" y="0"></rect>
<rect height="100" width="10" x="40" y="0"></rect>
<rect height="100" width="10" x="60" y="0"></rect>
</svg>
</div>
<div class="container mx-auto px-6 grid grid-cols-1 lg:grid-cols-2 gap-16 items-center relative z-10">
<!-- Left Side Content -->
<div>
<h1 class="font-headline font-black text-6xl md:text-8xl text-white leading-[0.9] tracking-tighter italic mb-8 uppercase">
                BẮT ĐẦU<br/>HÀNH TRÌNH<br/>CỦA BẠN
            </h1>
<p class="text-on-primary text-xl font-body max-w-md opacity-90 mb-12">
                Hãy để lại thông tin để nhận được tư vấn lộ trình tập luyện cá nhân hóa và ưu đãi thành viên mới nhất.
            </p>
<div class="space-y-6">
<div class="flex items-center gap-4 text-white">
<span class="material-symbols-outlined font-bold text-2xl" style="font-variation-settings: 'FILL' 1;">check_circle</span>
<span class="font-label font-bold uppercase tracking-widest text-sm md:text-base">TRẢI NGHIỆM 7 NGÀY MIỄN PHÍ</span>
</div>
<div class="flex items-center gap-4 text-white">
<span class="material-symbols-outlined font-bold text-2xl" style="font-variation-settings: 'FILL' 1;">check_circle</span>
<span class="font-label font-bold uppercase tracking-widest text-sm md:text-base">PHÂN TÍCH CHỈ SỐ CƠ THỂ INBODY</span>
</div>
</div>
</div>
<!-- Right Side Form (Styled as requested) -->
<div class="bg-[#f3f4f0] p-8 md:p-12 rounded-2xl shadow-2xl shadow-black/40">
<form class="space-y-6">
<div>
<label class="block font-label text-xs font-black uppercase tracking-widest text-on-surface-variant mb-2">Họ và tên</label>
<input class="w-full bg-[#e8e9e4] border-none rounded-lg p-5 font-headline font-bold text-on-surface placeholder:text-outline-variant focus:ring-2 focus:ring-primary transition-all" placeholder="NGUYỄN VĂN A" type="text"/>
</div>
<div>
<label class="block font-label text-xs font-black uppercase tracking-widest text-on-surface-variant mb-2">Số điện thoại</label>
<input class="w-full bg-[#e8e9e4] border-none rounded-lg p-5 font-headline font-bold text-on-surface placeholder:text-outline-variant focus:ring-2 focus:ring-primary transition-all" placeholder="090 XXX XXXX" type="tel"/>
</div>
<div>
<label class="block font-label text-xs font-black uppercase tracking-widest text-on-surface-variant mb-2">Email (nếu có)</label>
<input class="w-full bg-[#e8e9e4] border-none rounded-lg p-5 font-headline font-bold text-on-surface placeholder:text-outline-variant focus:ring-2 focus:ring-primary transition-all" placeholder="example@email.com" type="email"/>
</div>
<button class="w-full bg-noir-gradient text-on-primary py-5 rounded-lg font-headline text-xl font-black uppercase tracking-tighter hover:scale-[1.02] active:scale-[0.98] transition-all shadow-xl shadow-primary/30 mt-4" type="submit">
                    ĐĂNG KÝ NGAY
                </button>
<p class="text-center text-[10px] font-label text-outline-variant uppercase tracking-widest mt-8 leading-relaxed">
                    Bằng cách đăng ký, bạn đồng ý với các điều khoản bảo mật của chúng tôi.
                </p>
</form>
</div>
</div>
</section>
<!-- Classes/Disciplines Section -->
<section class="py-32 bg-surface">
<div class="container mx-auto px-6">
<div class="flex justify-between items-end mb-16">
<div>
<h2 class="font-headline font-black text-5xl md:text-6xl text-on-surface tracking-tighter leading-none mb-4 uppercase">
                        CHƯƠNG TRÌNH<br/>TẬP LUYỆN
                    </h2>
<div class="w-24 h-2 bg-primary"></div>
</div>
<p class="max-w-xs text-on-surface-variant font-body font-medium hidden md:block">
                    Khám phá những bộ môn đỉnh cao được thiết kế để đẩy giới hạn bản thân lên một tầm cao mới.
                </p>
</div>
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
<!-- HIIT -->
<div class="group relative aspect-[3/4] overflow-hidden rounded-xl bg-surface-container-high transition-transform duration-500 hover:-translate-y-2">
<img alt="High intensity interval training session" class="w-full h-full object-cover grayscale transition-all duration-700 group-hover:grayscale-0 group-hover:scale-110" data-alt="Athlete performing intense workout in dark gym" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDD1HtJzLWL1wYXbJDAMiEVZUjObDdjcoa05wdAUtfz6bvmeCp4LieGfJx-9Cbg04vHlfuANZk2uDTAuxtlmXNVngMF-uHHetWQJOPxJfiaQ8-oiVH5TuWxkvGZOTahiQlAZ3RaaF0sYZGPB0VlaGWUorBmb9zJ1qhgG2u-PmUjK8Ia_KyW6Lr9jYBCiMjIIKlqJvPJpTexJSOr7ZKjqqXx7wwgIN-XUhgH4Rf8iR2DoAC5IBVVX32FeO_PVbeqDLBZIZ22Xz4LVIc"/>
<div class="absolute inset-0 bg-gradient-to-t from-black via-black/20 to-transparent"></div>
<div class="absolute bottom-6 left-6 right-6">
<div class="w-1 h-8 bg-primary mb-4"></div>
<h3 class="font-headline font-extrabold text-3xl text-white uppercase italic">HIIT</h3>
<p class="text-white/60 text-sm font-label mt-2">Đốt mỡ cường độ cao</p>
</div>
</div>
<!-- YOGA -->
<div class="group relative aspect-[3/4] overflow-hidden rounded-xl bg-surface-container-high transition-transform duration-500 hover:-translate-y-2 lg:mt-12">
<img alt="Yoga practitioner in professional studio" class="w-full h-full object-cover grayscale transition-all duration-700 group-hover:grayscale-0 group-hover:scale-110" data-alt="Person practicing yoga in a high-contrast studio" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD5c3ZLuTZkG1-6GkUbsz_7o9T8NzFoGhkCLZAmfCiZOmU4U9Oyh40U-9x6-iILzGDmDAfvf6knFfUvacZGGaOC5BBJRzqyOBoJDYAAtt9tsJ_6lJoTlzYC3JDUAwfUnbVI2tGKVGzwrglIr5lSokajR576gElsLmKcoUBugRD2z0fI3BZM9BoQ5Lkyz-kWJ5T6_c43qp5coZGnHvD3-OdtdlAu6Nb-7AP0LbGwYmb_IHBT_1RNlKuKSi8g9anTIiI0OcWopEf5XhY"/>
<div class="absolute inset-0 bg-gradient-to-t from-black via-black/20 to-transparent"></div>
<div class="absolute bottom-6 left-6 right-6">
<div class="w-1 h-8 bg-primary mb-4"></div>
<h3 class="font-headline font-extrabold text-3xl text-white uppercase italic">YOGA</h3>
<p class="text-white/60 text-sm font-label mt-2">Cân bằng &amp; Linh hoạt</p>
</div>
</div>
<!-- BOXING -->
<div class="group relative aspect-[3/4] overflow-hidden rounded-xl bg-surface-container-high transition-transform duration-500 hover:-translate-y-2">
<img alt="Boxing class with equipment" class="w-full h-full object-cover grayscale transition-all duration-700 group-hover:grayscale-0 group-hover:scale-110" data-alt="Boxing gloves and bag in atmospheric gym lighting" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA6pY9shezvfPIneS-XOzru3ksUBF9R435-1eIXmYmafWDRiZkV5Tha1h2KK9ecdVM9kgQjqK8tnyVVajqiMeqIcvTlqcKvFhB2Osg8ixbT6W2Hqtc3svDzTIFTpyEKVCZWXQoJkDFmDl1HTE8Dt8tyKEs1AFS06r7QEOXzvgDyQuiUVVi0q0OV3_RX5u4UODz9Tf9h96UI5c705wKA4_1YErSTRfgMAbv73y_q6kzKP0a_6crA02iulvUtPb-kvCQxzuv2sXtS_wg"/>
<div class="absolute inset-0 bg-gradient-to-t from-black via-black/20 to-transparent"></div>
<div class="absolute bottom-6 left-6 right-6">
<div class="w-1 h-8 bg-primary mb-4"></div>
<h3 class="font-headline font-extrabold text-3xl text-white uppercase italic">BOXING</h3>
<p class="text-white/60 text-sm font-label mt-2">Sức mạnh &amp; Tốc độ</p>
</div>
</div>
<!-- LIFTING -->
<div class="group relative aspect-[3/4] overflow-hidden rounded-xl bg-surface-container-high transition-transform duration-500 hover:-translate-y-2 lg:mt-12">
<img alt="Weightlifting plates and equipment" class="w-full h-full object-cover grayscale transition-all duration-700 group-hover:grayscale-0 group-hover:scale-110" data-alt="Heavy lifting equipment in a professional training facility" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBeP4cr8O-HoId7t7ZdiNxAHBt2QuzdTULN5i1zbsXXdrkJRR4xGa-5A6snOSN4eUbbsZ49Ujv7hat83IKvo6ELj-pZgI4eCW1fPwGv6MOI42LPBS4GHlsMOeh91FEyLyoV1bO8voSNPJwaRwJtGiM3XhCG9UnjxLARVX87k49QmdGLkI9mtrzfWNSdCEIWMiZGUyZLvlSg_lh5vRLzXgUa32myflrlszj23tptp3DYwCOj2nV4DNf6Q17EW9wtX6QzMQI1U1TzKyI"/>
<div class="absolute inset-0 bg-gradient-to-t from-black via-black/20 to-transparent"></div>
<div class="absolute bottom-6 left-6 right-6">
<div class="w-1 h-8 bg-primary mb-4"></div>
<h3 class="font-headline font-extrabold text-3xl text-white uppercase italic">LIFTING</h3>
<p class="text-white/60 text-sm font-label mt-2">Xây dựng cơ bắp</p>
</div>
</div>
</div>
</div>
</section>
<!-- The Network/Branches Section -->
<section class="py-32 bg-surface-container-low">
<div class="container mx-auto px-6">
<div class="text-center mb-20">
<h2 class="font-headline font-black text-5xl text-on-surface tracking-tighter italic uppercase">HỆ THỐNG PHÒNG TẬP</h2>
<div class="w-20 h-1 bg-primary mx-auto mt-4"></div>
</div>
<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
<!-- Branch 1 -->
<div class="bg-surface-container-highest p-8 rounded-lg group transition-all duration-300 hover:bg-white hover:shadow-2xl hover:shadow-black/5">
<div class="text-primary font-headline font-black text-4xl mb-4 italic">01</div>
<h3 class="font-headline font-bold text-2xl text-on-surface mb-4 uppercase">QUẬN 1</h3>
<p class="text-on-surface-variant font-body mb-6 text-sm leading-relaxed">
                        123 Lê Lợi, Phường Bến Thành, Quận 1, TP. Hồ Chí Minh
                    </p>
<a class="inline-flex items-center gap-2 font-label font-bold text-xs uppercase tracking-widest text-primary group-hover:gap-4 transition-all" href="#">
                        XEM BẢN ĐỒ <span class="material-symbols-outlined text-sm">arrow_forward</span>
</a>
</div>
<!-- Branch 2 -->
<div class="bg-surface-container-highest p-8 rounded-lg group transition-all duration-300 hover:bg-white hover:shadow-2xl hover:shadow-black/5">
<div class="text-primary font-headline font-black text-4xl mb-4 italic">02</div>
<h3 class="font-headline font-bold text-2xl text-on-surface mb-4 uppercase">QUẬN 7</h3>
<p class="text-on-surface-variant font-body mb-6 text-sm leading-relaxed">
                        456 Nguyễn Lương Bằng, Phường Tân Phú, Quận 7, TP. Hồ Chí Minh
                    </p>
<a class="inline-flex items-center gap-2 font-label font-bold text-xs uppercase tracking-widest text-primary group-hover:gap-4 transition-all" href="#">
                        XEM BẢN ĐỒ <span class="material-symbols-outlined text-sm">arrow_forward</span>
</a>
</div>
<!-- Branch 3 -->
<div class="bg-surface-container-highest p-8 rounded-lg group transition-all duration-300 hover:bg-white hover:shadow-2xl hover:shadow-black/5">
<div class="text-primary font-headline font-black text-4xl mb-4 italic">03</div>
<h3 class="font-headline font-bold text-2xl text-on-surface mb-4 uppercase">BÌNH THẠNH</h3>
<p class="text-on-surface-variant font-body mb-6 text-sm leading-relaxed">
                        789 Bạch Đằng, Phường 24, Quận Bình Thạnh, TP. Hồ Chí Minh
                    </p>
<a class="inline-flex items-center gap-2 font-label font-bold text-xs uppercase tracking-widest text-primary group-hover:gap-4 transition-all" href="#">
                        XEM BẢN ĐỒ <span class="material-symbols-outlined text-sm">arrow_forward</span>
</a>
</div>
</div>
</div>
</section>
<!-- Footer -->
<footer class="bg-neutral-300 dark:bg-neutral-950 w-full py-12 px-8">
<div class="grid grid-cols-1 md:grid-cols-4 gap-8 max-w-7xl mx-auto">
<div class="col-span-1 md:col-span-1">
<div class="text-lg font-bold text-neutral-800 dark:text-neutral-200 font-headline uppercase italic mb-4">KINETIC NOIR</div>
<p class="text-neutral-500 font-body text-xs leading-relaxed">
                    Nền tảng tập luyện chuyên nghiệp hàng đầu với trang thiết bị hiện đại và đội ngũ huấn luyện viên tâm huyết.
                </p>
</div>
<div class="flex flex-col gap-3">
<h4 class="font-headline font-bold text-sm text-neutral-800 dark:text-neutral-200 uppercase tracking-widest mb-2">Navigation</h4>
<a class="text-neutral-500 font-body text-sm hover:text-neutral-800 dark:hover:text-white hover:underline decoration-red-600 decoration-2 underline-offset-4 transition-colors duration-300" href="#">Privacy Policy</a>
<a class="text-neutral-500 font-body text-sm hover:text-neutral-800 dark:hover:text-white hover:underline decoration-red-600 decoration-2 underline-offset-4 transition-colors duration-300" href="#">Terms of Service</a>
</div>
<div class="flex flex-col gap-3">
<h4 class="font-headline font-bold text-sm text-neutral-800 dark:text-neutral-200 uppercase tracking-widest mb-2">Connect</h4>
<a class="text-neutral-500 font-body text-sm hover:text-neutral-800 dark:hover:text-white hover:underline decoration-red-600 decoration-2 underline-offset-4 transition-colors duration-300" href="#">Affiliates</a>
<a class="text-neutral-500 font-body text-sm hover:text-neutral-800 dark:hover:text-white hover:underline decoration-red-600 decoration-2 underline-offset-4 transition-colors duration-300" href="#">Contact</a>
</div>
<div class="flex flex-col gap-4">
<h4 class="font-headline font-bold text-sm text-neutral-800 dark:text-neutral-200 uppercase tracking-widest mb-2">Follow Us</h4>
<div class="flex gap-4">
<div class="w-8 h-8 rounded bg-neutral-400/20 flex items-center justify-center text-neutral-600 dark:text-neutral-400 hover:bg-primary hover:text-white cursor-pointer transition-all">
<span class="material-symbols-outlined text-base">public</span>
</div>
<div class="w-8 h-8 rounded bg-neutral-400/20 flex items-center justify-center text-neutral-600 dark:text-neutral-400 hover:bg-primary hover:text-white cursor-pointer transition-all">
<span class="material-symbols-outlined text-base">podcasts</span>
</div>
</div>
</div>
</div>
<div class="mt-12 pt-8 border-t border-neutral-400/20 max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-4">
<div class="text-neutral-500 font-body text-xs tracking-wide">
                © 2024 KINETIC NOIR. PERFORMANCE ENGINEERED.
            </div>
<div class="flex items-center gap-2 text-primary font-headline font-bold text-[10px] tracking-[0.2em] uppercase">
                Powering the future of fitness
            </div>
</div>
</footer>
</body></html>