# Principals to follow, in order of importance

## Ubiquitous Language
- Use good names that describe the domain accurately
Good:
```typescript
class Invoice
class CustomerAccount
class SubscriptionPlan
class RenewalPolicy
```
Bad:
```typescript
class InvoiceDataManager
class CustomerAccountProcessor
class SubscriptionPlanHandler
```

- Name by role, not type
Good:
```typescript
users
invoicesById
customerProfile
```
Bad:
```typescript
userList
invoiceMap
dataObject
```

- Be consistent
Do not mix:
```
getUser()
fetchCustomer()
loadAccount()
retrieveMember()
```

## High cohesion, low coupling
- Things that change together, live together
- Unrelated things do not know too much about each other
Bad:
```
UserService
    - creates users
    - sends invoices
    - validates coupons
    - talks to Stripe
    - renders email templates
    - checks permissions
```
Good:
```
Users
Billing
Payments
Authorization
Notifications
```

## YAGNI
- Do not build the thing you don't need

## KISS (Keep it simple stupid)
- The code you never wrote, never breaks
- When solving problems, ask these questions, in this order
1. Do we need to solve this at all?
2. Is there a native solution or existing dependency that solves all/most of this?
3. Is there an existing solution in the codebase we can re-use?
4. If not, solve the problem with the minimal code necessary

## AHA over DRY (Avoid Hasty Abstractions vs Don't Repeat Yourself)
- Duplication is sometimes better than the wrong abstraction.
- Abstractions should be derived from emergence, not invented up front.
- Abstractions are vital for scaling systems. They SHOULD be done, just not hastily.

## Consistency beats cleverness
- Follow convention when practical.
- Challenge convention when appropriate.
- Refactoring unrelated code is better than embracing bad conventions.


# Development steps

1. Start with sparring on skeleton design. Rough type definitions, function stubs and module layout. Do not implement anything unless directly instructed to.
2. Move towards contractual definitions etc. to solidify approach and get feedback.
3. Flesh out implementation by adding minimal todos in the appropriate code location and get feedback.
4. Follow instructions for final implementation

As a general rule, follow these steps to the letter.
