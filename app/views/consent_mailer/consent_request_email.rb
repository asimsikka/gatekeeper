<p>Hello,</p>
<p>
  <%= @user.name %> (age <%= @user.age %>) has registered and requires your consent.
</p>
<p>
  Please approve by clicking:
  <%= link_to 'Approve Consent', edit_parental_consent_url(token: @consent.token) %>
</p>
