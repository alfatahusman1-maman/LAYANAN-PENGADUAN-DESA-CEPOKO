---
name: Sistem Pengaduan Digital Desa Cepoko
colors:
  surface: '#fbf9f9'
  surface-dim: '#dbdad9'
  surface-bright: '#fbf9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3f3'
  surface-container: '#efeded'
  surface-container-high: '#e9e8e7'
  surface-container-highest: '#e3e2e2'
  on-surface: '#1b1c1c'
  on-surface-variant: '#414941'
  inverse-surface: '#303031'
  inverse-on-surface: '#f2f0f0'
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
  tertiary: '#003f0b'
  on-tertiary: '#ffffff'
  tertiary-container: '#005914'
  on-tertiary-container: '#7ecf79'
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
  tertiary-fixed: '#a3f69c'
  tertiary-fixed-dim: '#88d982'
  on-tertiary-fixed: '#002204'
  on-tertiary-fixed-variant: '#005312'
  background: '#fbf9f9'
  on-background: '#1b1c1c'
  surface-variant: '#e3e2e2'
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
    lineHeight: 24px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
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
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
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
The design system bridges official public governance with local agrarian warmth. Designed for village residents ranging from tech-savvy youth to elder community members, the interface prioritizes approachability, high legibility, and transparency. 

The aesthetic is Modern-Civic: clean, structured, and reassuring. It avoids bureaucratic coldness by incorporating rich organic forest greens and warm earthen wood tones, evoking community trust, communal collaboration (*gotong royong*), and civic clarity. Visual clutter is stripped away in favor of generous touch targets, clear status progression, and comfortable contrast.

## Colors
The color palette reflects the rural identity of Desa Cepoko while maintaining civic authority and accessible contrast levels.

- **Primary (`#1E5631`)**: Forest Green communicates village governance, environmental sustainability, and integrity. Used for key interactive triggers, primary buttons, top app bars, and active navigation indicators.
- **Primary Container (`#E8F5E9`)**: Soft mint tint for focused field fills, selected chips, and primary accent highlights.
- **Secondary / Earth Accent (`#8D6E63`)**: Warm wood tan representing community soil, craft, and agrarian roots. Applied to secondary actions, category tags, and procedural workflows.
- **Secondary Container (`#EFEBE9`)**: Muted sand wash used for secondary chip backgrounds and card headers.
- **Neutral Surface (`#F8F9FA`)**: An ultra-soft off-white for grouping cards and surface sections, reducing glare while maintaining contrast over `#FFFFFF` canvas.
- **Text & Foreground**: Heavy charcoal (`#212121`) for high-contrast, effortless readability; medium gray (`#757575`) for assistive metadata.
- **Civic Status Hierarchy**:
  - *Pending / Menunggu*: Warm Amber (`#E65100`) on subtle amber surface (`#FFF3E0`).
  - *In Progress / Diproses*: Earth Brown (`#8D6E63`) on stone wash (`#EFEBE9`).
  - *Resolved / Selesai*: Emerald Green (`#2E7D32`) on pale green tint (`#E8F5E9`).

## Typography
Plus Jakarta Sans is utilized across display, body, and label roles to guarantee crisp optical legibility on mobile screens under high outdoor glare. Its balanced geometric letterforms and open apertures make reporting forms and case details immediately readable across diverse demographics.

Headlines employ bold weights to anchor page navigation and card titles. Body copy adheres strictly to a 1.4–1.5 line height ratio for comfortable reading of detailed citizen reports. Labels and status chips rely on medium-to-semibold weights to ensure clear legibility even at compact sizes.

## Layout & Spacing
The layout follows a mobile-first 4-column fluid grid tailored for one-handed handheld use, expanding to an 8-column layout for tablets and landscape orientations.

- **Screen Margins**: Fixed at `1rem` (16px) on mobile viewports to maximize usable surface space while keeping touch interactions comfortably away from curved hardware edges.
- **Rhythm**: Driven by an 8px vertical grid, with an auxiliary 4px sub-grid for badge padding and icon-to-label gaps (`space-xs`).
- **Touch Ergonomics**: All interactive elements maintain a minimum touch bounding box of 48x48px. Spacing between stacked interactive cards adheres to `space-md` (16px) to avoid accidental taps.

## Elevation & Depth
Elevation conveys actionable status and layer separation without heavy drop shadows that introduce visual noise.

- **Level 0 (Flat)**: Background canvas (`#FFFFFF`) and inactive inline containers.
- **Level 1 (Default Surface / Cards)**: Soft tint surface (`#F8F9FA`) with a subtle 1px structural border (`rgba(30, 86, 49, 0.08)`) and an ambient shadow: `0 2px 8px rgba(33, 33, 33, 0.04)`.
- **Level 2 (Active/Pressed Cards & Modals)**: Lifted surface utilizing `0 8px 16px rgba(30, 86, 49, 0.08)`.
- **Level 3 (Floating Action Button & Bottom Bar)**: Elevation dedicated to persistent primary utilities: `0 6px 20px rgba(30, 86, 49, 0.22)`.

## Shapes
Shapes adhere to modern Material 3 conventions with friendly, approachable geometry.

- **Cards & Modal Sheets**: Styled with `rounded-lg` (16px) to produce a calm, friendly enclosure for complaint cards, photo previews, and status logs.
- **Input Controls**: Use a consistent 12px corner radius, balancing structured data-entry feel with softness.
- **Pills & Status Tags**: Fully rounded (`9999px`) to immediately distinguish informative badges and chips from clickable rectangular cards.
- **Floating Action Button (Buat Laporan)**: Rounded-xl (20px) to draw focus as the core civic action.

## Components

### Buttons
- **Primary FAB ("Lapor")**: Sits anchored at bottom-right or centered dock. Forest Green background (`#1E5631`), white text/icon, elevated with Level 3 shadow. 
- **Standard Primary**: Solid Forest Green, height 48px, 12px radius, bold text centered, full width for form submissions.
- **Secondary / Neutral Action**: Secondary Container (`#EFEBE9`) fill with `#8D6E63` text, or transparent background with 1.5px outline in `#8D6E63`.

### Status Badges & Chips
- Designed as compact pill shapes (`rounded-full`, 24px height).
- Composed of subtle tinted backgrounds paired with deep high-contrast text:
  - *Pending*: Background `#FFF3E0`, text and dot icon `#E65100`.
  - *Diproses*: Background `#EFEBE9`, text and gear icon `#8D6E63`.
  - *Selesai*: Background `#E8F5E9`, text and check icon `#2E7D32`.

### Cards (Ticket / Pengaduan Feed)
- Background `#F8F9FA`, border 1px solid `rgba(0, 0, 0, 0.06)`, radius 16px, padding 16px.
- Top section holds reference code and status chip; body displays the issue description and optional 3:2 cropped photo attachment; footer indicates RT/RW location and timestamp.

### Input Fields
- Clear outline inputs: 1.5px border in `#757575` (resting) transitioning to `#1E5631` (focused) with an optional subtle primary focus halo.
- Labels float or sit persistently above inputs in Medium weight (`#212121`).
- Dedicated image upload box with dashed border in `#8D6E63` and an embedded camera icon.

### Timeline & Progress Stepper
- Vertical trail showing status transitions (Diajukan -> Diverifikasi -> Diproses -> Selesai).
- Active nodes colored in Primary `#1E5631` connected by a continuous 2px rail.