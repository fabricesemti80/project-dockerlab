# Cloudflare Access (Zero Trust) Setup

This project uses **Cloudflare Access** to secure all subdomains (`*.krapulax.dev`).

## 1. How it works
1.  **Terraform:** Configures the **Application** ("Lab Wildcard Access") and the **Policies** (Allow specific emails).
2.  **Dashboard:** You must manually configure the **Identity Providers** (Google, GitHub, etc.) that users can click to log in.

## 2. Setting up Identity Providers (IdP)

You must enable at least one Identity Provider for the login page to work.

1.  Go to the [Cloudflare Zero Trust Dashboard](https://one.dash.cloudflare.com/).
2.  Navigate to **Settings** > **Authentication**.
3.  Under **Login methods**, click **Add new**.
4.  Select your provider (e.g., **Google** or **GitHub**).
5.  Follow the instructions to generate Client ID and Secret:
    *   **Google:** Requires creating an OAuth 2.0 Client in Google Cloud Console.
    *   **GitHub:** Requires creating an OAuth App in GitHub Developer Settings.
    *   **One-Time PIN:** The easiest option (sends a code to your email). No external setup required.

## 3. Allowed Users
The following emails are currently authorized in `terraform/main_access.tf`:
- `emilfabrice@gmail.com`
- `gabriellagungl@gmail.com`
- `fabrice.semti@gmail.com`
- `fabrice@fabricesemti.com`

## 4. Troubleshooting Login
- **"This account does not have access":** This means the email returned by the Identity Provider (e.g., GitHub) is **not** in the list above.
- **Check your IdP Email:** If logging in with GitHub, ensure your primary/public email matches one of the allowed emails.
