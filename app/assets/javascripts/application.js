// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require_tree ./channels

var past_messages_downloaded, myusers_for_message_forum
var client_public_key, client_private_key, server_public_key, crypt, previous_messages , next_messages, allow_new_messages, message_packets, message_id
var message_forum_name
var job_email_availability, job_email_other, job_email_type

function show_public_key()  {
  alert ("Key1 = " + this.server_public_key);
};
