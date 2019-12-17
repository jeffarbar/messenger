<script>
import Message from './Message';
import groupBy from 'lodash/groupBy';
import moment from 'moment';


export default {
    components: {
        Message
    },
    filters: {
        conversationDate(date) {
    
            var dataMensagem =  String(date).split(" ")[0]
            if( dataMensagem ==  moment(String(new Date())).format('DD/MM/YYYY')){
               return "Hoje"
            }

            return dataMensagem
        }
    },
    data () {
        return {
    
            loading: false,
            conversation: {},
            messages: [],
            message: ''
        }
    },
    computed: {
        peer() {
            return this.$store.getters.currentPeer;
        },
        messagesGroupedByDate() {
            return this._groupMessagesByDate(this.messages.reverse());
        }
    },
    watch: {
        peer (peer_id) {
            this.getHistory(peer_id);
        }
    },
    beforeMount() {
        if (this.peer != 0) {
            this.getHistory(this.peer);
        }
    },
    mounted() {
        setInterval(
            () => {
                this.getHistory()
            }, 
            1000 * 60 * 3
        );
    },
    updated() {
        this.$refs.historyView.scrollTop = this.$refs.historyView.scrollHeight;
    },
    methods: {

        getHistory: function(peer_id) {
            this.loading = true;
            this.messages = [];

            if( peer_id == null || peer_id == undefined ){
               peer_id = this.$store.getters.currentPeer;
            }

            this.$http.get('http://13.90.142.231:8072/send/mensagem/'+peer_id)
            .then(response => {
                /*
                if (typeof response.body.response.profiles !== 'undefined') {
                    response.body.response.profiles.map(user => {
                        this.$store.commit('addUser', user);
                    });
                }

                if (typeof response.body.response.groups !== 'undefined') {
                    response.body.response.groups.map(group => {
                        this.$store.commit('addGroup', group);
                    });
                }
                */
                this.messages = response.body;
                //this.conversation = this.messages[0];

                this.loading = false;
            });
        },
        send: function() {
          
            if( this.message != null  && this.message != ''){
                
                this.loading = true;
                var mensagem = {"idMonitoredPont":this.peer,"content": this.message , 'direction':'0'}
                this.$http.post(
                    'http://13.90.142.231:8072/send/mensagem/', mensagem 
                    
                ).then(response => {
                    this.loading = false;
                    this.message = '';
                    
                    this.getHistory(this.peer);
                });
            }
        },
        _groupMessagesByDate(messages) {
            return groupBy(messages, function (message) {
                return moment.unix(message.createdAt).startOf('day').format();
            });
        }
    }
}
</script>

<template>
    <div class="dialog-info">
        <div class="conversation-header" v-if="peer !== 0">
            <div class="conversation__name">{{peer}}</div>
        </div>

        <div class="im-history" ref="historyView">
            <div v-if="loading" class="spinner"></div>
            <div v-else-if="peer === 0" class="im-placeholder">Por favor selecione um diálogo</div>
            <div v-else-if="messages.length == 0" class="im-placeholder">O histórico de correspondência será exibido aqui.</div>
            
            <div v-for="(messagesAtDay, createdAt) in messagesGroupedByDate" :key="createdAt">
                <template>
                    <!-- <div class="im-history-date">{{createdAt | conversationDate}}</div> -->
                    <div class="im-history-date">{{ messagesAtDay[ messagesAtDay.length - 1 ].createdAt | conversationDate}}</div>
                    
                    <message
                    
                        v-for="message in messagesAtDay"
                        :key="message.id"
                        :message="message"
                        :in-read="conversation.in_read"
                        :out-read="conversation.out_read"
                    />
                </template>
            </div>
        </div>

        <!-- <message-form :peer="peer" v-if="peer !== 0"/> -->
        <div v-if="peer !== 0" class="im-send-form">
            <textarea v-model="message" name="message" class="im-send-form__textarea" placeholder="Escreva uma mensagem ..."></textarea>
            <button class="im-send-form__submit-button" v-on:click="send"></button>
        </div>
    </div>

</template>

<style>
.conversation-header {
    display: flex;
    align-items: center;
    flex-shrink: 0;
    z-index: 5;
    height: 57px;
    background: #fff;
    border-bottom: 1px solid #e4e6e9;
    white-space: nowrap;
    font-size: 13px;
    line-height: 18px;
}
.conversation__name {
    line-height: 26px;
    margin: 15px 20px;
    font-weight: bold
}

.im-history {
	display: flex;
	flex-direction: column;
	overflow-y: scroll;
	flex-grow: 1;
}

.im-history-date {
    color: #828282;
    text-align: center;
    font-size: 14px;
    line-height: 18px;
    padding: 3px 15px;
}

.im-placeholder {
	color: #929eb0;
	font-size: 13px;
	display:flex;
	flex-grow:1;
	text-align: center;
	align-items: center;
	justify-content: center;
	padding-top: 100px; /* Image at top */
	background: url("https://vk.com/images/icons/empty_icon.png") no-repeat center;
	user-select: none
}

/** */

.im-send-form {
	padding: 0 0 0 10px;
	display: flex;
	flex-direction: row;
	flex-shrink: 0;
	border-top: solid 1px #e4e6e9;
	background: #fafbfc;
}

.im-send-form__textarea {
	flex-grow: 1;
	font-size: 13px;
	height: 36px;
	min-height: 36px;
	max-height: 200px;
	border-radius: 6px;
    line-height: 17px;
	padding: 9px 74px 10px 13px;
	margin: 12px 0;
	border: solid 1px #d3d9de;
	outline: 0;
}

.im-send-form__submit-button {
    align-self: flex-end;
 
    background:url('./../assets/svg/envia.png') no-repeat;

	background-size: 40px 40px;
	width: auto;
    height: auto;
	border: none;
	outline: none;
    padding: 25px 20px;
    cursor: pointer;
	opacity: 0.7;
	animation: 0.15s linear 0s im-zoom-appear;
}
.im-send-form__submit-button:hover {
	opacity: 1;
}

.svg-icon {
  width: 1em;
  height: 1em;
}

.svg-icon path,
.svg-icon polygon,
.svg-icon rect {
  fill: #4691f6;
}

.svg-icon circle {
  stroke: #4691f6;
  stroke-width: 1;
}

</style>
