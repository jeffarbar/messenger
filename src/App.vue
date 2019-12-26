<script>
import Conversations from './components/Conversations';
import Conversation from './components/Conversation';

export default {
    components: {
        Conversations,
        Conversation
    }
}
</script>

<template>
    <div class="context_" >
        <div class="im-container">
            <conversations></conversations>
            <conversation></conversation>
        </div>
       
        <div class="copyright">
            &copy; {{ new Date().getFullYear() }}
            powered by Send Solutions<br>
            contato@sendsolutions.me
        </div>
    </div>
</template>

<style>

.context_{
    flex-grow: 1;
}

.copyright{
    text-align: center;
    font-size: 12px;
}

.im-container {
    display: flex;
    flex-grow: 1;
	background: #fff;
	border-radius: 3px;
	box-shadow: 0 1px 0 0 #d7d8db, 0 0 0 1px #e3e4e8;
	height: 90vh;
	margin: 20px auto;
	overflow: hidden;
	max-width: 1000px;
}

@media only screen and (max-width: 768px) {
    .conversations-page {
        width: 100% !important;
    }
    .dialog-info {
        display: none;
    }
    .im-container {
        margin: 0;
        height: 100vh;
    }
}
</style>
