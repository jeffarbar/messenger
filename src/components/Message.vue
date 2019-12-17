<script>
import Attachment from './attachments/Attachment.vue';

export default {
    props: ['message', 'in-read', 'out-read'],
    computed: {
        peer: function() {
            return this.$store.getters.peerById(this.message.from_id);
        }
    },
    components: {
        Attachment
    },
    filters: {
        nl2br: function(str, isXhtml) {
            return String(str).replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1<br>$2');
        }
    },
    methods: {
    
        lida: function(idMensagem) {
            this.message.lida = true
            console.log(idMensagem) 

            this.$http.get(
                'http://13.90.142.231:8072/send/mensagem/ler/'+idMensagem).then(response => {
            });
        },
    }
}
</script>

<template>
    <div class="im-history__message" v-bind:class="{'im-history__message_unread': message.lida}">
        <!--<a :href="'https://vk.com/id'+message.from_id" target="__blank"> -->
       
        <img src="./../assets/svg/profile.png" class="im-history__message__photo user-photo"> 
        
        <!--</a>-->
        <div class="im-history__message__body">
            <a href="#" @click="lida(message.id)" >
                <div class="im-history__message__meta">
                    <!--<a :href="'https://vk.com/id'+message.from_id" class="im-history__message__username" target="__blank">-->
                        <!--
                        <template v-if="peer.name">{{peer.name}}</template>
                        <template v-else>{{peer.first_name}}</template>
                        -->
                        <template>{{message.idMonitoredPont}} </template>
                    <!--</a>-->
                    <span class="im-history__message__time">{{message.createdAt}}</span>
                </div>
                <div class="im-history__message__text" v-html="$options.filters.nl2br($options.filters.linkify(message.content))"></div>
            </a>    
            <div class="im-history__message__text__marca">
                <img v-if="message.lida" src="./../assets/svg/lida.png">
                <img v-else-if="message.recebida" src="./../assets/svg/recebida.png">
            </div>
            <!--
            <div class="im-history__message__text" v-html="$options.filters.nl2br($options.filters.linkify(message.text))"></div>
            <template v-if="message.fwd_messages">
                <div v-for="fwd_message in message.fwd_messages" v-bind:key="fwd_message.date">
                    <strong>Forwarded message from id{{fwd_message.from_id}}:</strong> {{fwd_message.text}}
                </div>
            </template>

            <attachment v-for="attachment in message.attachments" :attachment="attachment" :key="attachment.id"></attachment>
            -->
        </div>
       
    </div>
</template>

<style>
.im-history__day {
    color: #828282;
    text-align: center;
    font-size: 12.5px;
    background: #fff;
    font-weight: 400;
    position: relative;
    margin: 10px 43px;
    border: none;
    padding: 0;
}

.im-history__message {
    display: flex;
    flex-shrink: 0;
    font-size: 13px;
    border-radius: 3px;
    margin: 0 10px;
    overflow: hidden;
    padding: 5px 20px;
}
.im-history__message_unread {
    background: #edf0f5;
}

.im-history__message__body {
    overflow: hidden;
    margin: 0 10px;
    flex-grow: 1;
    flex-shrink: 1;
}
.im-history__message__photo {
    background-color: #fafbfc;
    flex-shrink: 0;
    height: 36px;
    width: 36px;
    margin: 5px;
    margin-left: 15px;
}
.im-history__message__meta {
    font-size: 12px;
    margin-top: 10px;
}
.im-history__message__text {
    margin-top: 5px;
    word-wrap: break-word;
}
.im-history__message__text__marca {
    margin-top: 5px;
    text-align: right
}
.im-history__message__username {
    max-width: 200px;
    font-weight: bold;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    display: inline-block;
    vertical-align: top;
    margin-right: 10px;
}
.im-history__message__time {
    font-weight: 400;
    color: rgba(120, 127, 140, 0.6);
}



</style>
