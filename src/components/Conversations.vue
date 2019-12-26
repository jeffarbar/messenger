<script>
import ConversationsItem from './ConversationsItem.vue';
//import ConversationsSearch from './ConversationsSearch.vue';

export default {
    data () {
        return {
            conversations: [],
            conversationsAux: [],
            loading: false,
            query: ''
        };
    },
    methods: {
        pesquisar: function () {

            let aux = [];
            if( this.query != null && this.query != undefined && this.query != '' ){
                let quantidade = this.conversationsAux.length;  
                for (var i= 0; i < quantidade; i++ ) {
                    if( this.conversationsAux[i].nome.toUpperCase().indexOf(this.query.toUpperCase()) > -1 ){
                         aux.push( this.conversationsAux[i] );   
                    }
                };
                this.conversations = aux;
            }else{
                this.getConversations()
            }
        },
        getConversations: function () {
            
            var idUser = this.$route.fullPath 

            this.loading = true;
            this.conversations = []
            this.$http.get('http://13.90.142.231:8082/rastreamento/pontoMonitorado/usuario' + idUser)
            .then(response => {
                this.loading = false;
                this.conversations = response.body;
                this.conversationsAux =  this.conversations
            });

            /*
            let conversa = { 'idMonitoredPont' : '42q424sdad', 'content':'com foi','online':false , 
            'createdAt':'2019-10-10' , lida:true}

             let conversa1 = { 'idMonitoredPont' : '42q424sdad1', 'content':'aaa','online':false , 
            'createdAt':'2019-10-10', lida:false}
            
             let conversa2 = { 'idMonitoredPont' : '42q424sdad2', 'content':'cade vc ','online':true , 
            'createdAt':'202019-10-10191', lida:true}

            this.conversations.push(conversa)
            this.conversations.push(conversa1)
            this.conversations.push(conversa2)
          
            

            if (!this.conversations.length) {
                this.loading = true;
            }
              */

            /*
            this.$http.jsonp('https://api.vk.com/method/messages.getConversations', {
                params: {
                    v: '5.80',
                    access_token: this.$store.state.token,
                    count: 100,
                    offset: 0,
                    extended: 1 // + profiles and groups
                }
            })
            .then(response => {
                this.loading = false;
                this.conversations = response.body.response.items;

                response.body.response.profiles.map(user => {
                    this.$store.commit('addUser', user);
                });
                
                response.body.response.groups.map(group => {
                    this.$store.commit('addGroup', group);
                });
            }).catch(error => {
                setTimeout(this.getConversations, 5000);
            });/
            */
        }
    },
    beforeMount() {
        this.getConversations();
    },
    mounted() {
        /*
        setInterval(
            () => {
                this.getConversations()
            }, 
            1000 * 60 * 10
        );
        */
    },
    components: {
        ConversationsItem
        //ConversationsSearch
    }
}
</script>

<template>
    <aside class="conversations-page">
        <div class="conversations-header">
             <div class="dialogs-search">
                <input type="search" v-model="query" v-on:keyup="pesquisar" class="dialogs-search__field" placeholder="Pesquisar">
            </div>
            <!--
            <conversations-search></conversations-search>
            -->
             <!--
            <button class="menu-button"></button>
            -->
        </div>
        
        <div v-if="loading" class="spinner"></div>
        <transition-group v-else tag="div" class="conversations-list" name="fade">
            <conversations-item
                v-for="dialog in conversations"
                :dialog="dialog"
                :key="dialog.identificador"
            ></conversations-item>
        </transition-group>
    </aside>
</template>

<style>
.conversations-page {
    display: flex;
    flex-direction: column;
    border-right: solid 1px #e4e6e9;
	flex-shrink: 0;
    flex-grow: 0;
    width: 350px;
}

.conversations-list {
	overflow-x: hidden;
	overflow-y: scroll;
	-webkit-overflow-scrolling: touch;
}
.conversations-header {
    display: flex;
    background: #fff;
    border-bottom: solid 1px #e4e6e9;
    flex-direction: row;
    flex-shrink: 0;
}
.menu-button {
    background:url("../assets/svg/dots.svg") 50% no-repeat;
    width: 36px;
    height: 36px;
    border:0;
    margin: 10px;
    padding: 0;
    outline: 0;
    opacity: .8;
}
.menu-button:hover,
.menu-button:focus {
    opacity: 1;
}
.menu-button:active {
    transform: translateY(1px);
}
.dialogs-search {
    display: flex;
    flex-grow: 1;
}
.dialogs-search__field {
	flex-grow: 1;
	flex-shrink: 0;
	background-color: #eef1f4;
	border: 0;
	border-radius: 3px;
	font-size: 14px;
	padding: 10px;
	margin: 10px;
	outline: none;
}
.dialogs-search__field::placeholder {
	color: #9ca2ad;
}
</style>
