/**
 * RESTORE EXPRESS - E-COMMERCE & REPAIR STOREFRONT ENGINE
 * - Mobile Navigation Toggle
 * - Category & Condition Facet Filter
 * - Store Product Search & Sort Controller
 */

document.addEventListener('DOMContentLoaded', () => {

    /* --- 1. MOBILE MENU TOGGLE --- */
    const menuToggle = document.getElementById('menu-toggle');
    const navLinks = document.querySelector('.nav-links');

    if (menuToggle && navLinks) {
        menuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
        });
    }

    /* --- 2. FACET FILTERING & SEARCH CONTROLLER --- */
    const auctionGrid = document.getElementById('auction-grid');
    const facetCheckboxes = document.querySelectorAll('.facet-checkbox');
    const typePills = document.querySelectorAll('.type-pill');
    const inlineSearch = document.getElementById('inline-search');
    const sortSelect = document.getElementById('sort-select');
    const resetBtn = document.getElementById('reset-filters-btn') || document.getElementById('empty-reset-btn');

    typePills.forEach(pill => {
        pill.addEventListener('click', () => {
            typePills.forEach(p => p.classList.remove('active'));
            pill.classList.add('active');
            applyFilters();
        });
    });

    facetCheckboxes.forEach(cb => cb.addEventListener('change', applyFilters));

    if (inlineSearch) {
        inlineSearch.addEventListener('input', applyFilters);
    }

    if (sortSelect) {
        sortSelect.addEventListener('change', applyFilters);
    }

    if (resetBtn) {
        resetBtn.addEventListener('click', () => {
            facetCheckboxes.forEach(cb => cb.checked = true);
            if (inlineSearch) inlineSearch.value = '';
            typePills.forEach(p => p.classList.remove('active'));
            if (typePills[0]) typePills[0].classList.add('active');
            applyFilters();
        });
    }

    function applyFilters() {
        if (!auctionGrid) return;
        const cards = Array.from(auctionGrid.querySelectorAll('.auction-card'));

        const checkedConditions = Array.from(document.querySelectorAll('input[name="condition"]:checked')).map(cb => cb.value);
        const searchText = inlineSearch ? inlineSearch.value.trim().toLowerCase() : '';

        const activePill = document.querySelector('.type-pill.active');
        const pillType = activePill ? activePill.getAttribute('data-type') : 'ALL';

        let visibleCount = 0;

        cards.forEach(card => {
            const title = (card.getAttribute('data-title') || card.querySelector('.lot-title')?.textContent || '').toLowerCase();
            const brand = (card.getAttribute('data-brand') || '').toLowerCase();
            const cond = card.getAttribute('data-condition') || '';

            let matchesType = true;
            if (pillType === 'NEW') matchesType = (cond === 'NEW');
            if (pillType === 'REFURBISHED') matchesType = (cond.startsWith('REFURBISHED'));

            const matchesCondition = checkedConditions.length === 0 || checkedConditions.includes(cond);
            const matchesSearch = !searchText || title.includes(searchText) || brand.includes(searchText);

            if (matchesType && matchesCondition && matchesSearch) {
                card.style.display = 'flex';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        if (sortSelect) {
            sortCards(cards, sortSelect.value);
        }

        const countDisplay = document.getElementById('results-count-number');
        if (countDisplay) {
            countDisplay.textContent = visibleCount;
        }
    }

    function sortCards(cards, sortVal) {
        cards.sort((a, b) => {
            const priceA = parseInt(a.getAttribute('data-price') || '0', 10);
            const priceB = parseInt(b.getAttribute('data-price') || '0', 10);

            if (sortVal === 'price-low') return priceA - priceB;
            if (sortVal === 'price-high') return priceB - priceA;
            if (sortVal === 'title-az') {
                const titleA = (a.querySelector('.lot-title')?.textContent || '').trim();
                const titleB = (b.querySelector('.lot-title')?.textContent || '').trim();
                return titleA.localeCompare(titleB);
            }
            return 0;
        });

        cards.forEach(card => auctionGrid.appendChild(card));
    }
});
