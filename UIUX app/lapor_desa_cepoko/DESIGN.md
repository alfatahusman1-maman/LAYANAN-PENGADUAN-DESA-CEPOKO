---
name: Lapor Desa Cepoko
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1b1c1c'
  on-surface-variant: '#414941'
  inverse-surface: '#303030'
  inverse-on-surface: '#f3f0ef'
  outline: '#717970'
  outline-variant: '#c0c9be'
  surface-tint: '#326942'
  primary: '#003e1c'
  on-primary: '#ffffff'
  primary-container: '#1e5631'
  on-primary-container: '#8fca9b'
  inverse-primary: '#99d4a4'
  secondary: '#75584d'
  on-secondary: '#ffffff'
  secondary-container: '#fed7ca'
  on-secondary-container: '#795c51'
  tertiary: '#631e00'
  on-tertiary: '#ffffff'
  tertiary-container: '#892d00'
  on-tertiary-container: '#ffa786'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#b5f1bf'
  primary-fixed-dim: '#99d4a4'
  on-primary-fixed: '#00210c'
  on-primary-fixed-variant: '#18512c'
  secondary-fixed: '#ffdbce'
  secondary-fixed-dim: '#e4beb2'
  on-secondary-fixed: '#2b160f'
  on-secondary-fixed-variant: '#5b4137'
  tertiary-fixed: '#ffdbcf'
  tertiary-fixed-dim: '#ffb59a'
  on-tertiary-fixed: '#380d00'
  on-tertiary-fixed-variant: '#802a00'
  background: '#fcf9f8'
  on-background: '#1b1c1c'
  surface-variant: '#e5e2e1'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  title-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system powers the digital public grievance and reporting platform for the village administration of Cepoko. The platform bridges grassroots rural citizens with local village authorities (*Aparatur Desa*), requiring an aesthetic that balances institutional authority with pastoral, welcoming warmth. 

The design narrative combines **Modern Public Governance** with an **Agrarian Earthiness**, rooted structurally in Material Design 3 guidelines tailored for mobile devices. The visual persona communicates transparency, responsiveness, civic trust, and accessibility. The emotional tone avoids bureaucratic coldness; it reassures village residents that their voices, infrastructure reports, and administrative requests are acknowledged and actively managed.

Visual execution relies on clean whitespace, organic forest and earth tones, legible typography, and tactical status indicators that make report lifecycles unmistakable even for users with low digital literacy.

## Colors

The palette directly reflects village governance, regional forestry, and structured civic workflow states:

- **Primary (`#1E5631`)**: Forest Green evokes official village authority, environmental health, stability, and integrity. Used for the top app bars, primary action buttons, focused controls, and prominent brand anchors.
- **Secondary (`#8D6E63`)**: Warm Wood Tan / Earthy Brown provides warmth and craft. Applied to contextual chips, administrative timeline markers, secondary cards, and the *Diproses* (In Progress) progress state.
- **Tertiary (`#E65100`)**: Warm Amber / Deep Ochre reserved for urgent notifications, attention markers, and the *Pending* / *Menunggu* submission state.
- **Success / Resolved (`#2E7D32`)**: Emerald Green dedicated to *Selesai* (Resolved) verification badges, success dialogues, and positive resolution tags.
- **Neutral Primary (`#212121`)**: Near-black tone for maximum reading contrast across high-sunlight outdoor mobile conditions.
- **Neutral Secondary (`#757575`)**: Supporting grey for metadata, timestamps, input placeholders, and secondary body captions.
- **Surfaces (`#FFFFFF` & `#F8F9FA`)**: Crisp white base canvas layered with soft neutral grey surface containers for clear visual grouping of card clusters.

## Typography

The type scale utilizes **Plus Jakarta Sans**, offering geometric clarity, open apertures, and friendly rounded terminals that ensure instant legibility across small mobile displays and varying screen densities.

Headlines command respect without appearing intimidating. Titles and subtitles organize civic reports into distinct hierarchies, while body copy ensures complaints and administrative updates are easily read. Uppercase treatments are strictly reserved for `label-sm` badges and official administrative reference numbers (e.g., ticket identifiers like `#LP-2024-001`).

## Layout & Spacing

The layout operates on a mobile-first 4-column grid spanning an outer margin of `16px` (`margin: 1rem`), expandable to an 8-column layout on tablet viewports with `24px` margins. 

Spacing rhythm adheres strictly to an 8px baseline framework (with a 4px half-step for micro-elements):
- **Component Padding**: Standard card internal padding is `space-md` (16px) for balanced content density.
- **Vertical Flow**: Sections on the feed (e.g., stats banner, report category carousels, recent grievances) maintain `space-lg` (24px) vertical separation.
- **Touch Targets**: All interactive elements (FAB, navigation bar items, list chevrons, form fields) comply with minimum 48x48px hit areas to accommodate practical thumb reach on handheld devices.

## Elevation & Depth

Visual hierarchy uses Material 3 surface tinting and ambient drop shadows rather than hard structural lines:

- **Level 0 (Flat)**: Baseline background canvas (`#FFFFFF` or `#F8F9FA`).
- **Level 1 (Card Default)**: `box-shadow: 0px 1px 3px rgba(33, 33, 33, 0.08), 0px 1px 2px rgba(33, 33, 33, 0.04)`. Used for grievance timeline cards, category select blocks, and report summaries.
- **Level 2 (Active/Hover Cards)**: `box-shadow: 0px 4px 8px rgba(33, 33, 33, 0.10), 0px 2px 4px rgba(33, 33, 33, 0.06)`. Used when cards are pressed or elevated during interactive drag states.
- **Level 3 (Sticky Bars & Floating Action Buttons)**: `box-shadow: 0px 6px 16px rgba(30, 86, 49, 0.20)`. The report creation Floating Action Button utilizes a forest-green tinted ambient drop shadow to emphasize its primary call to action.
- **Level 4 (Modals & Bottom Sheets)**: `box-shadow: 0px -4px 20px rgba(0, 0, 0, 0.12)`. Applied to bottom sheets for photo attachments, category pickers, and citizen verification dialogues.

## Shapes

The design system embraces a **Rounded (Level 2)** geometry to soften the institutional nature of civic interactions:

- **Small Components (Badges, Status Pills, Mini-Chips)**: Full pill radius (`9999px`) to emphasize encapsulation.
- **Form Controls & Inputs**: `12px` border radius for friendly, approachable fields.
- **Cards & Banners**: `16px` border radius, creating comfortable visual compartments on high-DPI displays.
- **Bottom Sheets & Dialogue Panels**: `24px` top corner radius for an inviting slide-up presentation.

## Components

### Buttons
- **Primary CTA ("Kirim Laporan")**: Filled surface in Primary Forest Green (`#1E5631`) with high-contrast White text (`#FFFFFF`), `12px` radius, height 48px, bold label.
- **Secondary Action**: Outlined border (1.5px `#8D6E63`) with secondary tan typography, no background fill.
- **Floating Action Button (FAB)**: Primary color fill with white plus icon, 56x56px, fully rounded (or 16px squash-circle), floating at `margin-bottom: 24px`, `margin-right: 16px`.

### Status Badges & Pills
- **Pending / Menunggu**: Background `#FFF3E0`, text & dot `#E65100`, pill-shaped, `label-sm` semibold.
- **Diproses (In Progress)**: Background `#EFEBE9`, text & dot `#8D6E63`, pill-shaped, `label-sm` semibold.
- **Selesai (Resolved)**: Background `#E8F5E9`, text & dot `#2E7D32`, pill-shaped, `label-sm` semibold.

### Report Cards
- Background `#FFFFFF` sitting on `#F8F9FA` background canvas.
- Encased with a `1px` subtle outline (`#EEEEEE`) and Level 1 ambient elevation.
- 16px border-radius.
- Internal hierarchy: Header row with ticket reference ID and status pill; middle block with complaint headline and brief snippet; footer row with relative timestamp (e.g., "2 jam lalu"), village sub-region (RT/RW), and comment/photo count indicators.

### Form Inputs & Uploaders
- **Text Inputs**: Outlined style with `12px` radius, neutral border (`#E0E0E0`), shifting to `#1E5631` with a 2px stroke upon focus. Floating label positioned per Material 3 guidelines.
- **Media/Photo Uploader**: Dashed border container (`#8D6E63` at 40% opacity), soft background (`#F8F9FA`), housing an icon button for geo-tagged image uploads of local infrastructure issues.

### Official Badge
- Reserved for verified village officers (*Perangkat Desa*). Subtle micro-pill with an emerald checkmark and `#1E5631` text over a soft sage tint (`#E8F5E9`), establishing trust in administrative responses.