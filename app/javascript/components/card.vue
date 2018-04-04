<template>
<div>
  <div @click="editing=true" class="card card-body ">
      <h3>{{ card.name }}</h3>
  </div>

  <div v-if="editing" class="modal-backdrop show"></div>

  <div v-if="editing" @click="closeModal" class="modal show" style="display: block">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{{ card.name }} </h5>
        </div>

        <div class="modal-body">
          <input v-model="name" class="form-control" />
        </div>

        <div class="modal-footer">
          <button @click="save" type="button" class="btn btn-primary">Save changes</button>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<script>
export default{
  props: ['card', 'list'],
  data: function() {
    return {
      editing: false,
      name: this.card.name
    }
  },

  methods: {
    closeModal: function(){
      if (event.target.classList.contains("modal")) {
        this.editing = false
      }
    },
    save: function(){
      var crd_data = new FormData();

      crd_data.append("card[name]", this.name)

      Rails.ajax({
        url: `/cards/${this.card.id}`,
        type: "PATCH",
        data: crd_data,
        dataType: 'json',
        beforeSend: () => {
          return true
        },
        success: (data) => {
          //this.$store.commit('editCard', data)

          this.editing = false
        }
      })

    },
  }
}
</script>

<style scoped>
.card {
  background: #fff;
}
</style>
