# Design System Specification: High-End Tactical Editorial

## 1. Overview & Creative North Star: "The Tactical Precision"
The objective of this design system is to transcend the generic "gun range" aesthetic and establish a digital environment that feels like a high-end, secure, and precision-engineered tool.

**Creative North Star: The Precision Instrument.**
Like a custom-milled slide or a high-end optic, the UI should feel intentional, weighted, and impeccably organized. We achieve this by moving away from "web-standard" borders and grids, instead utilizing **Tonal Layering** and **Asymmetrical Tension**. We use heavy, bold typography to anchor the eye, while leveraging sophisticated dark-mode depth (Charcoal and Slate) to provide a canvas for our "Safety Orange" accents. The layout should breathe—use whitespace not as "empty" space, but as a tactical buffer that highlights the most critical data points.

---

## 2. Colors: Depth over Boundaries
We strictly follow a "No-Line" philosophy. Physicality is created through shifting luminosity, not 1px strokes.

### Color Tokens
* **Surface Foundation:** `surface` (#131313) is our void.
* **Tactical Accents:** `primary` (#ffb59c) and `primary_container` (#ff5f1f) act as our "Safety Orange." These are reserved for critical actions and status-critical alerts. `tertiary` (#a0d663) serves as our "Tactical Green" for successful states and confirmed bookings.
* **The "No-Line" Rule:** Do not use `outline` or solid 1px borders to separate sections. Contrast is achieved by placing a `surface_container_low` (#1C1B1B) section against a `surface` (#131313) background.
* **Glass & Gradient Rule:** For elevated components (like floating booking summaries), use `surface_bright` at 60% opacity with a `backdrop-filter: blur(12px)`. Apply a subtle linear gradient to main CTAs (from `primary` to `primary_container`) to give them a metallic, machined sheen.

---

## 3. Typography: Authoritative Clarity
We pair the geometric, technical feel of **Space Grotesk** with the high-utility legibility of **Inter**.

* **Display & Headlines (Space Grotesk):** Use `display-lg` (3.5rem) and `headline-lg` (2rem) for hero titles and membership tiers. The wide apertures of Space Grotesk convey a modern, "tech-forward" ruggedness.
* **Navigation & Titles (Inter):** Use `title-lg` (1.375rem) for section headers. Inter provides a neutral, professional balance to the expressive headlines.
* **Labels & Metadata (Inter):** Use `label-md` (0.75rem) for tactical data points (e.g., "LANE STATUS," "CALIBER LIMITS"). All-caps styling with 0.05em letter-spacing is encouraged for labels to mimic military equipment marking.

---

## 4. Elevation & Depth: The Layering Principle
We move away from the flat web. Hierarchy is communicated through "stacking" luminosity.

* **Tonal Layering:**
* **Level 0 (Base):** `surface` (#131313).
* **Level 1 (Sections):** `surface_container_low` (#1C1B1B).
* **Level 2 (Cards/Modules):** `surface_container` (#201F1F).
* **Level 3 (Floating Modals):** `surface_container_highest` (#353534).
* **Ambient Shadows:** Use shadows sparingly. When a "Status Indicator" or "Booking Card" needs to float, use a soft `0px 20px 40px rgba(0,0,0,0.4)`. The shadow should feel like ambient occlusion, not a harsh drop-shadow.
* **Ghost Border Fallback:** If a container sits on a surface of the same color, use a "Ghost Border": `outline_variant` at 15% opacity. It should be felt, not seen.

---

## 5. Components: Rugged Sophistication

### Buttons & Interaction
* **Primary Action (Booking):** Large `xl` (0.75rem) rounded corners. Background is a vertical gradient of `primary` to `primary_container`. Text is `on_primary` (#5C1900), bold.
* **Secondary Action:** `surface_container_highest` background with no border. On hover, shift to `surface_bright`.
* **Tactical Status Indicators:** Small, circular pips using `tertiary` (Available) or `error` (Occupied/Down). Use a subtle pulse animation for "Live" range states.

### Cards & Membership Tiers
* **The "No-Divider" Rule:** Never use a horizontal line to separate content within a card. Use `8` (2rem) spacing from the Spacing Scale to create grouping.
* **Tier Cards:** Use `surface_container_high` for the card body. Highlight "VIP" or "Pro" tiers by applying a `primary` "Ghost Border" (20% opacity) and a `primary_fixed_dim` label at the top-right.

### Booking Forms & Inputs
* **Fields:** Use `surface_container_lowest` for input backgrounds. This "sunken" look provides clear affordance for data entry.
* **Focus State:** Do not use a blue glow. Use a 2px `primary` (Orange) bottom-border (or "Ghost Border" wrap) to indicate focus.

### Additional App-Specific Components
* **Range Map Nodes:** Interactive lane icons. Use `surface_variant` for occupied lanes and `tertiary_container` for your reserved lane.
* **Safety Checklists:** Custom checkboxes with a `lg` (0.5rem) radius. When checked, the fill should be `tertiary` with an `on_tertiary` checkmark.

---

## 6. Do’s and Don’ts

### Do:
* **Use Intentional Asymmetry:** In hero sections, align text to the left but place secondary tactical data (like "Range Temperature" or "Active Shooters") offset to the right using `24` (6rem) spacing.
* **Embrace High Contrast:** Keep text high-contrast (`on_surface`) against the dark background to ensure readability in low-light range environments.
* **Use Soft Roundedness:** Stick to `xl` (0.75rem) for large cards and `md` (0.375rem) for smaller buttons to maintain the "modern-yet-rugged" balance.

### Don't:
* **No Hairline Dividers:** Avoid using 1px borders to separate list items. Use a background color shift or `1.5` (0.375rem) of vertical space.
* **No Pure Black:** Avoid `#000000`. Use `surface` (#131313) to allow for depth and soft shadows to remain visible.
* **No Standard Blue:** Never use default browser blues for links or buttons. This system relies on Orange and Green to communicate action and safety.